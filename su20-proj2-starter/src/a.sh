#!/bin/bash
#Author:孙言笑 3200104609
#Name:ex_1.sh
#Create time:2022-12-1
#Description:如果这个文件是一个普通文件，则打印文件所有者的名字和最后的修改日期。如果程序带有多个参数，则输出出错信息。
if test $# -ne 1  #判断参数个数是否为1
then
    echo "Please input one parameter"  #输出错误信息
    exit 1
fi
if test -f "$1" #判断文件是否为普通文件
then 
    filename="$1"
        set -- $(ls -l $filename --full-time) #列出文件的相关信息
        echo "The filename is $filename."      #打印文件名
        echo "The oner is $3."                 #打印文件所有者名字
        echo "The last modify time is ${6} ${7} ${8}." #打印最后修改时间
        exit 0
fi
echo "$1 is not an ordinary file."      #输出出错信息
exit 0

#!/bin/bash
#Author:孙言笑 3200104609
#Name:ex_2.sh
#Create time:2022-12-1
#Description:统计指定目录下的普通文件、子目录及可执行文件的数目，统计该目录下所有普通文件字节数总和
if [ $# -ne 1 ] || !(test -e "$1") || !(test -d "$1") #判断是否输入一个存在的目录
then
    echo "Please input one existed dictionary."   #打印出错信息
    exit 1
fi
name="$1"
ordinary=$(find $name -type f | wc -l)   #查找普通文件并统计数目
echo "The number of ordinary file is $ordinary" #打印普通文件的数目
sub=$(find $name -type d | wc -l)        #查找目录并统计数目
echo "The number of sub directory $[ $sub-1 ]."  #打印子目录的数目
exe=$(find $name -type f -executable | wc -l)  #查找可执行文件并统计数目
echo "The number of executable file is $exe."  #打印可执行文件数目
num=0
array=$(find $name)
for file in $array
do 
    if [ -f "$file" ]  #判断是否为普通文件
    then
        set -- $(wc -c $file) #统计普通文件的字节数
        num=$[ $num+$1 ]
    fi
done
echo "The character of ordinary file is $num." #打印普通文件字节数总和
exit 0

#!/bin/bash
read -a arrayecho "




function copy_content()
{
    for file in `ls $1/*`
    do
        if [ -f "$1/$file" ];then
            if [ ! -f "$2/$file" ];then
                cp "$1/$file" "$2/$file";
            elif [ "$1/$file" -nt "$2/$file" ];then
                cp "$1/$file" "$2/$file"
            fi
        elif [ -d "$1/$file" ];then
            if [ ! -d "$2/$file" ];then
                mkdir "$2/$file";
                copy_content "$1/$file" "$2/$file"
            elif [ "$1/$file" -nt "$2/$file" ];then
                copy_content "$1/$file" "$2/$file"
            fi
        fi
    done
}

function sync_content_dst(){
    dst="$2/*" 
    for file in $dst
    do
        if [ -d "$2/$file" ];then
            if [ -d "$1/$file" ];then
                sync_content_dst() $1/$file $2/$file
            else
                rm -r "$2/$file"
            fi
        else 
            if [ ! (-e "$1/$file") || (-d "$1/$file") ];then
                rm -rf "$2/$file";
            elif [ "$2/$file" -nt "$1/$filr" ];then
                cp $2/$file $1/$file
            fi
        fi
    done
}
function sync_content_src(){
    src="$1/*" 
    for file in $src
    do
        if [ -d "$1/$file" ];then
            if [ -d "$2/$file" ];then
                sync_content_src() $1/$file $2/$file
            else
                rm -r "$1/$file"
            fi
        else 
            if [ ! -e "$2/$file") ] || [ -d "$2/$file" ];then
                rm -rf "$1/$file";
            elif [ "$1/$file" -nt "$2/$filr" ];then
                cp $1/$file $2/$file
            fi
        fi
    done
}

if [ $# -ne 3 ] || [ ! -d $2 ]
then
    echo "Usage: $0 -option src_directory des_directory"
    echo "-b : back-up"
    echo "-s : syncchronization"
    exit 1
elif [ $1 != "-b" ] && [ $1 != "-s" ]
then
    echo "Usage: $0 -option src_directory des_directory"
    echo "-b : back-up"
    echo "-s : syncchronization"
    exit 1
fi

if [ "$1" == "-b" ];then
    echo "begin back-up..."
    copy_content $2 $3
    exit 0
elif [ "$1" == "-s" ];then
    echo "begin sync..."
    sync_content_dst $2 $3
    sync_content_src $2 $3
    exit 0
fi
