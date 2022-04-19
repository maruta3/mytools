#! /bin/sh

#引数の処理をする
aws_access_key_id="";
aws_secret_access_key="";
aws_session_token="";
while [ "$1" != "" ]
do
  if [ $1 = "--aws_access_key_id" ];
  then
    shift;
    aws_access_key_id=$1;
  elif [ $1 = "--aws_secret_access_key" ];
  then
    shift;
    aws_secret_access_key=$1;
  elif [ $1 = "--aws_session_token" ];
  then
    shift;
    aws_session_token=$1;
  elif [ $1 = "--help" ];
  then
    echo "updateAwsSessionToken.sh --aws_access_key_id <aws_access_key_id> --aws_secret_access_key <aws_secret_access_key> --aws_session_token <aws_session_token>";
    exit 0;
  fi
  shift
done

awk 'BEGIN{row="";FS=" "}{if($1=="[mfa]"){print $0;row=NR}else if(NR==row+1 && row){print "aws_access_key_id = '$aws_access_key_id'"}else if(NR==row+2 && row){print "aws_secret_access_key = '$aws_secret_access_key'"}else if(NR==row+3 && row){print "aws_session_token = '$aws_session_token'"}else{print$0}}' ~/.aws/credentials > ~/.aws/credentials.tmp

cp ~/.aws/credentials.tmp ~/.aws/credentials

