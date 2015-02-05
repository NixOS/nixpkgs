
# Building bootstrap tools
echo Building the trivial bootstrap environment...
$mkdir -p $out/bin

$ln -s $ln $out/bin/ln

PATH=$out/bin/

cd $out/bin

ln -s $mkdir
ln -s /bin/sh
ln -s /bin/cp
ln -s /bin/mv
ln -s /bin/rm
ln -s /bin/ls
ln -s /bin/ps
ln -s /bin/cat
ln -s /bin/bash
ln -s /bin/echo
ln -s /bin/expr
ln -s /bin/test
ln -s /bin/date
ln -s /bin/chmod
ln -s /bin/rmdir
ln -s /bin/sleep
ln -s /bin/hostname

ln -s /usr/bin/id
ln -s /usr/bin/od
ln -s /usr/bin/tr
ln -s /usr/bin/wc
ln -s /usr/bin/cut
ln -s /usr/bin/cmp
ln -s /usr/bin/sed
ln -s /usr/bin/tar
ln -s /usr/bin/xar
ln -s /usr/bin/awk
ln -s /usr/bin/env
ln -s /usr/bin/tee
ln -s /usr/bin/comm
ln -s /usr/bin/cpio
ln -s /usr/bin/curl
ln -s /usr/bin/find
ln -s /usr/bin/grep
ln -s /usr/bin/gzip
ln -s /usr/bin/head
ln -s /usr/bin/tail
ln -s /usr/bin/sort
ln -s /usr/bin/uniq
ln -s /usr/bin/less
ln -s /usr/bin/true
ln -s /usr/bin/diff
ln -s /usr/bin/egrep
ln -s /usr/bin/fgrep
ln -s /usr/bin/patch
ln -s /usr/bin/uname
ln -s /usr/bin/touch
ln -s /usr/bin/split
ln -s /usr/bin/xargs
ln -s /usr/bin/which
ln -s /usr/bin/install
ln -s /usr/bin/basename
ln -s /usr/bin/dirname
ln -s /usr/bin/readlink