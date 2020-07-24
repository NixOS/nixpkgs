set -e
set -o nounset
set -o pipefail

echo Building the trivial bootstrap environment...
echo
echo Needed FreeBSD packages:
echo findutils gcpio gawk gnugrep coreutils bash gsed gtar gmake xar binutils gpatch lbzip2 diffutils

$mkdir -p $out/bin

ln () {
  if [ ! -z "${2:-}" ]; then
    if [ -f "$out/bin/$2" ]; then
      echo "$2 exists"
      exit 1
    fi
  fi
  if test ! -f "$1"; then
    echo Target "$2" does not exist
    exit 1
  fi
  # TODO: check that destination directory exists
  if [ ! -z "${2:-}" ]; then
    $ln -s "$1" "$out/bin/$2"
  else
    $ln -s "$1" "$out/bin/"
  fi
}

ln /usr/local/bin/bash
ln /bin/sh

ln /usr/local/bin/gmake make

ln /usr/local/bin/lbzip2

ln /usr/local/bin/gdiff diff

ln /usr/bin/locale

ln /usr/bin/more

ln /usr/bin/hexdump # for bitcoin

ln /usr/bin/bzip2
ln /usr/bin/bunzip2
ln /usr/bin/bzcat
ln /usr/bin/bzip2recover

ln /usr/bin/xz
ln /usr/bin/unxz
ln /usr/bin/xzcat
ln /usr/bin/lzma
ln /usr/bin/unlzma
ln /usr/bin/lzcat

ln /usr/local/bin/gcp cp
ln /usr/local/bin/gdd dd
ln /usr/local/bin/gmv mv
ln /usr/local/bin/grm rm
ln /usr/local/bin/gls ls
ln /bin/ps ps
ln /usr/local/bin/gcat cat
ln /usr/local/bin/gecho echo
ln /usr/local/bin/gexpr expr
ln /usr/local/bin/gtest test
ln /usr/local/bin/gdate date
ln /usr/local/bin/gchmod chmod
ln /usr/local/bin/grmdir rmdir
ln /usr/local/bin/gsleep sleep
ln /bin/hostname hostname

ln /usr/local/bin/gid id
ln /usr/local/bin/god od
ln /usr/local/bin/gtr tr
ln /usr/local/bin/gwc wc
ln /usr/local/bin/gcut cut
ln /usr/bin/cmp cmp
ln /usr/local/bin/gsed sed
ln /usr/local/bin/gtar tar
ln /usr/local/bin/xar xar
ln /usr/local/bin/gawk awk
ln /usr/local/bin/genv env
ln /usr/local/bin/gtee tee
ln /usr/local/bin/gcomm comm
ln /usr/local/bin/gcpio cpio
ln /usr/local/bin/curl curl
ln /usr/local/bin/gfind find
ln /usr/local/bin/grep grep # other grep is in /usr/bin
ln /usr/bin/gzip
ln /usr/bin/gunzip
ln /usr/bin/zcat
ln /usr/local/bin/ghead head
ln /usr/bin/tail tail # note that we are not using gtail!!!
ln /usr/local/bin/guniq uniq
ln /usr/bin/less less
ln /usr/local/bin/gtrue true
# ln /usr/bin/diff diff # we are using gdiff (see above)
ln /usr/local/bin/egrep egrep
ln /usr/local/bin/fgrep fgrep
ln /usr/local/bin/gpatch patch
ln /usr/local/bin/guname uname
ln /usr/local/bin/gtouch touch
ln /usr/local/bin/gsplit split
ln /usr/local/bin/gxargs xargs
ln /usr/bin/which which
ln /usr/local/bin/ginstall install
ln /usr/local/bin/gbasename basename
ln /usr/local/bin/gdirname dirname
ln /usr/local/bin/greadlink readlink

ln /usr/local/bin/gln ln
ln /usr/local/bin/gyes yes
ln /usr/local/bin/gwhoami whoami
ln /usr/local/bin/gvdir vdir
ln /usr/local/bin/gusers users
ln /usr/local/bin/guptime uptime
ln /usr/local/bin/gunlink unlink
ln /usr/local/bin/gtty tty
ln /usr/local/bin/gunexpand unexpand
ln /usr/local/bin/gtsort tsort
ln /usr/local/bin/gtruncate truncate
ln /usr/local/bin/gtimeout timeout
ln /usr/local/bin/gtac tac
ln /usr/local/bin/gsync sync
ln /usr/local/bin/gsum sum
ln /usr/local/bin/gstty stty
ln /usr/local/bin/gstdbuf stdbuf
ln /usr/local/bin/gsort sort
ln /usr/local/bin/gruncon runcon
ln /usr/local/bin/gseq seq
ln /usr/local/bin/gsha1sum sha1sum
ln /usr/local/bin/gsha224sum sha224sum
ln /usr/local/bin/gsha256sum sha256sum
ln /usr/local/bin/gsha384sum sha384sum
ln /usr/local/bin/gsha512sum sha512sum
ln /usr/local/bin/gshred shred
ln /usr/local/bin/gshuf shuf
ln /usr/local/bin/grealpath realpath
ln "/usr/local/bin/g[" "["
ln /usr/local/bin/gbase64 base64
ln /usr/local/bin/gchcon chcon
ln /usr/local/bin/gchgrp chgrp
ln /usr/local/bin/gchown chown
ln /usr/local/bin/gchroot chroot
ln /usr/local/bin/gcksum cksum
ln /usr/local/bin/gcsplit csplit
ln /usr/local/bin/gdf df
ln /usr/local/bin/gdircolors dircolors
ln /usr/local/bin/gdu du
ln /usr/local/bin/gexpand expand
ln /usr/local/bin/gfactor factor
ln /usr/local/bin/gfalse false
ln /usr/local/bin/gfmt fmt
ln /usr/local/bin/gfold fold
ln /usr/local/bin/ggroups groups
ln /usr/local/bin/ghostid hostid
ln /usr/local/bin/gjoin join
ln /usr/local/bin/gkill kill
ln /usr/local/bin/glink link
ln /usr/local/bin/glogname logname
ln /usr/local/bin/gmd5sum md5sum
ln /usr/local/bin/gmkdir mkdir
ln /usr/local/bin/gmkfifo mkfifo
ln /usr/local/bin/gmknod mknod
ln /usr/local/bin/gmktemp mktemp
ln /usr/local/bin/gnice nice
ln /usr/local/bin/gnl nl
ln /usr/local/bin/gnohup nohup
ln /usr/local/bin/gnproc nproc
ln /usr/local/bin/gnumfmt numfmt
ln /usr/local/bin/gnustat nustat
ln /usr/local/bin/gpaste paste
ln /usr/local/bin/gpathchk pathchk
ln /usr/local/bin/gpinky pinky
ln /usr/local/bin/gpr pr
ln /usr/local/bin/gprintenv printenv
ln /usr/local/bin/gprintf printf
ln /usr/local/bin/gptx ptx
ln /usr/local/bin/gpwd pwd

# binutils
# pkg info -l binutils | grep usr/local/bin
ln /usr/local/bin/addr2line
ln /usr/local/bin/ar
ln /usr/local/bin/as
ln /usr/local/bin/c++filt
ln /usr/local/bin/dwp
ln /usr/local/bin/elfedit
ln /usr/local/bin/gprof
ln /usr/local/bin/ld
ln /usr/local/bin/ld.bfd
ln /usr/local/bin/ld.gold
ln /usr/local/bin/nm
ln /usr/local/bin/objcopy
ln /usr/local/bin/objdump
ln /usr/local/bin/ranlib
ln /usr/local/bin/readelf
ln /usr/local/bin/size
ln /usr/local/bin/strings
ln /usr/local/bin/strip

#pkg info -l llvm37 | grep usr/local/bin
