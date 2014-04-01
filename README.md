# gitstate

Bash script to show dirty git repos states under a path

## Install

Ensure `gitstate` is somewhere in your `$PATH`

## Usage

```
$ gitstate -p ./bash
./bash/gitstate
## master...origin/master [ahead 1]
 M README.md
 M gitstate.sh

./bash/rootbashrc
## master
 M README.md

REPOS:9  DIRTY:2  CLEAN:7
```

see `gitstate -h` for more options
