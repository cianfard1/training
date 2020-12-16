#! /bin/bash
if [[ -n "$1" ]] ;
then
    if [[ "$1" == *M ]];
    then 
      echo "executing the command $1 correctly"
      var="$1"
      withoutm=${var%?};
      echo $withoutm
    else
      echo "provide number with like 1024M"
      exit 0
    fi
else
    echo "no parameter provided"
    exit 0
fi
