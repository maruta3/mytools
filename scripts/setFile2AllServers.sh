#!/bin/bash

declare -a list=(
"backup2"
"backup3"
);

for e in ${list[@]};
do
  echo ${e}
  scp -pr /home/j-takasaki/.ssh ${e}:/home/j-takasaki/
  scp -pr /home/j-takasaki/.vimrc ${e}:/home/j-takasaki/
  scp -pr /home/j-takasaki/.gvimrc ${e}:/home/j-takasaki/
done

