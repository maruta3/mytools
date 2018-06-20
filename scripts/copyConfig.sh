#! /bin/sh

#引数の処理をする
server=""
while [ "$1" != "" ]
do
  if [ $1 = "--server" ];
  then
    shift
    server=$1
  fi
  shift
done

#対象サーバーなければエラーに
if [ ${#server} -le 0 ]
then
  echo "Missing Argument."
  exit
fi

scp -r /home/j-takasaki/.ssh $server:/home/j-takasaki/.
scp /home/j-takasaki/.vimrc $server:/home/j-takasaki/.
scp /home/j-takasaki/.gvimrc $server:/home/j-takasaki/.
#scp /home/j-takasaki/.gitconfig $server:/home/j-takasaki/.

