#!/bin/bash
usage()
{
cat << EOF

show status of git repos on the filesystem

OPTIONS:
    -q      do not output files
    -p      path to search

EOF
exit 1
}

spinner()
{
  spin='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
  # spin='⠋⠙⠚⠞⠖⠦⠴⠲⠳⠓'
  # spin='⠄⠆⠇⠋⠙⠸⠰⠠⠰⠸⠙⠋⠇⠆'
  # spin='⠋⠙⠚⠒⠂⠂⠒⠲⠴⠦⠖⠒⠐⠐⠒⠓⠋'
  # spin='⠁⠉⠙⠚⠒⠂⠂⠒⠲⠴⠤⠄⠄⠤⠴⠲⠒⠂⠂⠒⠚⠙⠉⠁'
  # spin='⠈⠉⠋⠓⠒⠐⠐⠒⠖⠦⠤⠠⠠⠤⠦⠖⠒⠐⠐⠒⠓⠋⠉⠈'
  # spin='⠁⠁⠉⠙⠚⠒⠂⠂⠒⠲⠴⠤⠄⠄⠤⠠⠠⠤⠦⠖⠒⠐⠐⠒⠓⠋⠉⠈⠈⠉'
  pid=$1
  msg='';
  if [ ! -z "$2" ];then
    msg="$2 "
  fi
  let spin_len=${#spin};
  i=0
  while kill -0 $pid 2>/dev/null
  do
    i=$(( (i+1) %${spin_len}  ))
    printf "\r${spin:$i:1} $msg"
    sleep .1
  done
}

while getopts "qp:" option
do
  case $option in
    q) QUIET=1;;
    p) SEARCH_PATH=$OPTARG;;
    \?) usage;exit 2;;
  esac
done

count_all=0;
count_clean=0;
count_dirty=0;

if [ -z "$SEARCH_PATH" ];then
  SEARCH_PATH='.'
fi

find_states(){
  for gitdir in `find $SEARCH_PATH -name .git`;
    do
      let count_all=$count_all+1;
      workTree=${gitdir%/*};

      if [[ "$(git --git-dir=$gitdir --work-tree=$workTree status 2> /dev/null | tail -n1 | cut -c 1-17)" != "nothing to commit" ]];then
        let count_dirty=$count_dirty+1;
        if [ "$workTree" == "." ];then
          echo -e "\r "
        else
          echo -e "\r$workTree";
        fi
        if [ "$QUIET" != "1" ];then
          git --git-dir=$gitdir --work-tree=$workTree status -sb;
          echo ""
        fi
      else
        let count_clean=$count_clean+1;
      fi
  done
}

find_states &
spinner $!
echo -e "\rREPOS:$count_all  DIRTY:$count_dirty  CLEAN:$count_clean";
exit 0
