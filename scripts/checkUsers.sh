#!/bin/bash

declare -a list=(
"backup2"
"backup3"
);

for e in ${list[@]};
do
  printf ${e}
  ssh ${e} cat /etc/passwd | awk 'BEGIN{FS=":";}{printf "\t"$1;}END{printf "\n";}'
done
