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

for gitdir in `find $SEARCH_PATH -name .git`;
  do
    let count_all=$count_all+1;
    workTree=${gitdir%/*};

    if [[ "$(git --git-dir=$gitdir --work-tree=$workTree status 2> /dev/null | tail -n1 | cut -c 1-17)" != "nothing to commit" ]];then
      let count_dirty=$count_dirty+1;
      echo $workTree;
      if [ "$QUIET" != "1" ];then
        git --git-dir=$gitdir --work-tree=$workTree status -sb;
        echo ""
      fi
    else
      let count_clean=$count_clean+1;
    fi
done

echo "REPOS:$count_all  DIRTY:$count_dirty  CLEAN:$count_clean";
exit 0
