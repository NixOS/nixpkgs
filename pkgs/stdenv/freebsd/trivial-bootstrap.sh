
# Building bootstrap tools
echo Building the trivial bootstrap environment...

# needed FreeBSD packages:
# findutils gcpio gawk gnugrep coreutils bash gsed gtar gmake xar binutils gpatch lbzip2 diffutils

$mkdir -p $out/bin

$ln -s $ln $out/bin/ln

PATH=$out/bin/

cd $out/bin

ln -s $mkdir

ln -s /usr/local/bin/bash
ln -s /bin/sh

ln -s /usr/local/bin/gmake make

ln -s /usr/local/bin/lbzip2

ln -s /usr/local/bin/gdiff diff

ln -s /usr/bin/locale

ln -s /usr/bin/more

ln -s /usr/bin/bzip2
ln -s /usr/bin/bunzip2
ln -s /usr/bin/bzcat
ln -s /usr/bin/bzip2recover

ln -s /usr/bin/xz
ln -s /usr/bin/unxz
ln -s /usr/bin/xzcat
ln -s /usr/bin/lzma
ln -s /usr/bin/unlzma
ln -s /usr/bin/lzcat

ln -s /usr/local/bin/gcp cp
ln -s /usr/local/bin/gdd dd
ln -s /usr/local/bin/gmv mv
ln -s /usr/local/bin/grm rm
ln -s /usr/local/bin/gls ls
ln -s /bin/ps ps
ln -s /usr/local/bin/gcat cat
ln -s /usr/local/bin/gecho echo
ln -s /usr/local/bin/gexpr expr
ln -s /usr/local/bin/gtest test
ln -s /usr/local/bin/gdate date
ln -s /usr/local/bin/gchmod chmod
ln -s /usr/local/bin/grmdir rmdir
ln -s /usr/local/bin/gsleep sleep
ln -s /bin/hostname hostname

ln -s /usr/local/bin/gid id
ln -s /usr/local/bin/god od
ln -s /usr/local/bin/gtr tr
ln -s /usr/local/bin/gwc wc
ln -s /usr/local/bin/gcut cut
ln -s /usr/bin/cmp cmp
ln -s /usr/local/bin/gsed sed
ln -s /usr/local/bin/gtar tar
ln -s /usr/local/bin/xar xar
ln -s /usr/local/bin/gawk awk
ln -s /usr/local/bin/genv env
ln -s /usr/local/bin/gtee tee
ln -s /usr/local/bin/gcomm comm
ln -s /usr/local/bin/gcpio cpio
ln -s /usr/local/bin/curl curl
ln -s /usr/local/bin/gfind find
ln -s /usr/local/bin/grep grep #other grep is in /usr/bin
ln -s /usr/bin/gzip
ln -s /usr/bin/gunzip
ln -s /usr/bin/zcat
ln -s /usr/local/bin/ghead head
ln -s /usr/bin/tail tail
ln -s /usr/local/bin/guniq uniq
ln -s /usr/bin/less less
ln -s /usr/local/bin/gtrue true
ln -s /usr/bin/diff diff
ln -s /usr/local/bin/egrep egrep
ln -s /usr/local/bin/fgrep fgrep
ln -s /usr/local/bin/gpatch patch
ln -s /usr/local/bin/guname uname
ln -s /usr/local/bin/gtouch touch
ln -s /usr/local/bin/gsplit split
ln -s /usr/local/bin/gxargs xargs
ln -s /usr/bin/which which
ln -s /usr/local/bin/ginstall install
ln -s /usr/local/bin/gbasename basename
ln -s /usr/local/bin/gdirname dirname
ln -s /usr/local/bin/greadlink readlink

ln -fs /usr/local/bin/gln ln
ln -s /usr/local/bin/gyes yes
ln -s /usr/local/bin/gwhoami whoami
ln -s /usr/local/bin/gvdir vdir
ln -s /usr/local/bin/gusers users
ln -s /usr/local/bin/guptime uptime
ln -s /usr/local/bin/gunlink unlink
ln -s /usr/local/bin/gtty tty
ln -s /usr/local/bin/gunexpand unexpand
ln -s /usr/local/bin/gtsort tsort
ln -s /usr/local/bin/gtruncate truncate
ln -s /usr/local/bin/gtimeout timeout
ln -s /usr/local/bin/gtac tac
ln -s /usr/local/bin/gsync sync
ln -s /usr/local/bin/gsum sum
ln -s /usr/local/bin/gstty stty
ln -s /usr/local/bin/gstdbuf stdbuf
ln -s /usr/local/bin/gsort sort
ln -s /usr/local/bin/gruncon runcon
ln -s /usr/local/bin/gseq seq
ln -s /usr/local/bin/gsha1sum sha1sum
ln -s /usr/local/bin/gsha224sum sha224sum
ln -s /usr/local/bin/gsha256sum sha256sum
ln -s /usr/local/bin/gsha384sum sha384sum
ln -s /usr/local/bin/gsha512sum sha512sum
ln -s /usr/local/bin/gshred shred
ln -s /usr/local/bin/gshuf shuf
ln -s /usr/local/bin/grealpath realpath
ln -s "/usr/local/bin/g[" "["
ln -s /usr/local/bin/gbase64 base64
ln -s /usr/local/bin/gchcon chcon
ln -s /usr/local/bin/gchgrp chgrp
ln -s /usr/local/bin/gchown chown
ln -s /usr/local/bin/gchroot chroot
ln -s /usr/local/bin/gcksum cksum
ln -s /usr/local/bin/gcsplit csplit
ln -s /usr/local/bin/gdf df
ln -s /usr/local/bin/gdircolors dircolors
ln -s /usr/local/bin/gdu du
ln -s /usr/local/bin/gexpand expand
ln -s /usr/local/bin/gfactor factor
ln -s /usr/local/bin/gfalse false
ln -s /usr/local/bin/gfmt fmt
ln -s /usr/local/bin/gfold fold
ln -s /usr/local/bin/ggroups groups
ln -s /usr/local/bin/ghostid hostid
ln -s /usr/local/bin/gjoin join
ln -s /usr/local/bin/gkill kill
ln -s /usr/local/bin/glink link
ln -s /usr/local/bin/glogname logname
ln -s /usr/local/bin/gmd5sum md5sum
ln -s /usr/local/bin/gmkdir mkdir
ln -s /usr/local/bin/gmkfifo mkfifo
ln -s /usr/local/bin/gmknod mknod
ln -s /usr/local/bin/gmktemp mktemp
ln -s /usr/local/bin/gnice nice
ln -s /usr/local/bin/gnl nl
ln -s /usr/local/bin/gnohup nohup
ln -s /usr/local/bin/gnproc nproc
ln -s /usr/local/bin/gnumfmt numfmt
ln -s /usr/local/bin/gnustat nustat
ln -s /usr/local/bin/gpaste paste
ln -s /usr/local/bin/gpathchk pathchk
ln -s /usr/local/bin/gpinky pinky
ln -s /usr/local/bin/gpr pr
ln -s /usr/local/bin/gprintenv printenv
ln -s /usr/local/bin/gprintf printf
ln -s /usr/local/bin/gptx ptx
ln -s /usr/local/bin/gpwd pwd

# binutils
# pkg info -l binutils | grep usr/local/bin
ln -s /usr/local/bin/addr2line
ln -s /usr/local/bin/ar
ln -s /usr/local/bin/as
ln -s /usr/local/bin/c++filt
ln -s /usr/local/bin/dwp
ln -s /usr/local/bin/elfedit
ln -s /usr/local/bin/gprof
ln -s /usr/local/bin/ld
ln -s /usr/local/bin/ld.bfd
ln -s /usr/local/bin/ld.gold
ln -s /usr/local/bin/nm
ln -s /usr/local/bin/objcopy
ln -s /usr/local/bin/objdump
ln -s /usr/local/bin/ranlib
ln -s /usr/local/bin/readelf
ln -s /usr/local/bin/size
ln -s /usr/local/bin/strings
ln -s /usr/local/bin/strip

#pkg info -l llvm37 | grep usr/local/bin
