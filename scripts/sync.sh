#!/bin/sh

inotifywait -e create,delete,modify,move -m -r /home/j-takasaki/repository/path_to_dir |
while read; do
    while read -t 0.3; do
        :
    done
    rsync -vruzalpc --delete /home/j-takasaki/repository/path_to_dir/ remote_host:/opt/remote_path/app/dev6/project/ --exclude=".git"
done
