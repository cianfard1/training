Role Name
=========

A brief description of the role goes here.

Requirements
------------

Any pre-requisites that may not be covered by Ansible itself or the role should be mentioned here. For instance, if the role uses the EC2 module, it may be a good idea to mention in this section that the boto package is required.

Role Variables
--------------

A description of the settable variables for this role should go here, including any variables that are in defaults/main.yml, vars/main.yml, and any variables that can/should be set via parameters to the role. Any variables that are read from other roles and/or the global scope (ie. hostvars, group vars, etc.) should be mentioned here as well.

Dependencies
------------

A list of other roles hosted on Galaxy should go here, plus any details in regards to parameters that may need to be set for other roles, or variables that are used from other roles.

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { role: username.rolename, x: 42 }

License
-------

BSD

Author Information
------------------

An optional section for the role authors to include contact information, or a website (HTML is not allowed).

text: description of ansible roles
-----------------

Run the following commands to create the structure needed for the role:
sudo mkdir /etc/ansible/roles/baseline && sudo chown ansible.ansible /etc/ansible/roles/baseline
mkdir /etc/ansible/roles/baseline/{templates,tasks,files}
echo "---" > /etc/ansible/roles/baseline/tasks/main.yml
check_circle
Configure the Role to Deploy the /etc/motd Template
cp /home/ansible/resources/motd.j2 /etc/ansible/roles/baseline/templates
Create a file called /etc/ansible/roles/baseline/tasks/deploy_motd.yml with the following content:
---
- template:
    src: motd.j2
    dest: /etc/motd
Edit /etc/ansible/roles/baseline/tasks/main.yml to include the following lines at the bottom of the file:
- name: configure motd
  import_tasks: deploy_motd.yml
check_circle
Configure the Role to Install the Latest Nagios Client
Create a file called /etc/ansible/roles/baseline/tasks/deploy_nagios.yml with the following content:
---
- yum: name=nrpe state=latest
Edit /etc/ansible/roles/baseline/tasks/main.yml to include the following lines at the bottom of the file (take care with the formatting.):
- name: deploy nagios client
  import_tasks: deploy_nagios.yml
check_circle
Configure the Role to Add an Entry to /etc/hosts for the Nagios Server
Create a file called /etc/ansible/roles/baseline/tasks/edit_hosts.yml with the following content, substituting <PROVIDED> with the IP specified in /home/ansible/resources/nagios_info.txt:
---
- lineinfile:
    line: "<<PROVIDED>PROVIDED> nagios.example.com"
    path: /etc/hosts
Edit /etc/ansible/roles/baseline/tasks/main.yml to include the following lines at the bottom of the file:
  - name: edit hosts file
    import_tasks: edit_hosts.yml
check_circle
Configure the Role to Create the noc User and Deploy the Provided Public Key for the noc User on Target Systems
Copy the file /home/ansible/resources/authorized_keys to /etc/ansible/roles/baseline/files/.
Create a file called /etc/ansible/roles/baseline/tasks/deploy_noc_user.yml with the following content:
---
- user: name=noc
- file:
     state: directory
     path: /home/noc/.ssh
     mode: 0600
     owner: noc
     group: noc
- copy:
        src: authorized_keys
        dest: /home/noc/.ssh/authorized_keys
        mode: 0600
        owner: noc
        group: noc
Edit /etc/ansible/roles/baseline/tasks/main.yml to include the following lines at the bottom of the file:
      - name: set up noc user and key
        import_tasks: deploy_noc_user.yml
check_circle
Edit web.yml to Deploy the baseline Role
Edit /home/ansible/resources/web.yml to the following:
---
- hosts: webservers
  become: yes
  roles:
    - baseline
  tasks:
    - name: install httpd
      yum: name=httpd state=latest
    - name: start and enable httpd
      service: name=httpd state=started enabled=yes
check_circle
Run Your Playbook Using the Default Inventory
Run ansible-playbook /home/ansible/resources/web.yml
