set -e
set -o nounset
set -o pipefail

echo Building the trivial bootstrap environment...
#echo
#echo Needed FreeBSD packages:
#echo findutils gcpio gawk gnugrep coreutils bash gsed gtar gmake xar binutils gpatch lbzip2 diffutils

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

ln $bash/bin/bash
ln $make/bin/make

ln /bin/sh

for i in b2sum base32 base64 basename basenc cat chcon chgrp chmod \
    chown chroot cksum comm cp csplit cut date dd df dir dircolors \
    dirname du echo env expand expr factor false fmt fold install \
    groups head hostid id join kill link ln logname ls md5sum mkdir \
    mkfifo mknod mktemp mv nice nl nohup nproc numfmt od paste pathchk \
    pinky pr printenv printf ptx pwd readlink realpath rm rmdir runcon \
    seq sha1sum sha224sum sha256sum sha384sum sha512sum shred shuf \
    sleep sort split stat stdbuf stty sum sync tac tee test timeout \
    touch tr true truncate tsort tty uname unexpand uniq unlink uptime \
    users vdir wc who whoami yes
do
    ln "$coreutils/bin/$i" "$i"
done

for i in find xargs; do
    ln "$findutils/bin/$i" "$i"
done

for i in diff diff3 sdiff; do
    ln "$diffutils/bin/$i" "$i"
done

for i in grep egrep fgrep; do
    ln "$grep/bin/$i" "$i"
done

ln /usr/bin/locale

ln /usr/bin/more

ln /usr/bin/hexdump # for bitcoin

ln /usr/bin/bzip2
ln /usr/bin/bunzip2
ln /usr/bin/bzip2recover

ln /usr/bin/xz
ln /usr/bin/unxz
ln /usr/bin/lzma
ln /usr/bin/unlzma

ln /bin/ps
ln /bin/hostname
ln /usr/bin/cmp
ln $sed/bin/sed
ln /usr/bin/tar tar
ln $gawk/bin/gawk
ln $gawk/bin/gawk awk
ln $cpio/bin/cpio
ln $curl/bin/curl curl
ln /usr/bin/gzip
ln /usr/bin/gunzip
ln /usr/bin/tail tail # note that we are not using gtail!!!
ln /usr/bin/less less
ln $patch/bin/patch patch
ln /usr/bin/which which

## binutils
# pkg info -l binutils | grep usr/local/bin
ln /usr/bin/addr2line
ln /usr/bin/ar
ln /usr/bin/as
ln /usr/bin/c++filt
#ln /usr/bin/dwp
#ln /usr/bin/elfedit
ln /usr/bin/gprof
ln /usr/bin/ld
#ln /usr/bin/ld.bfd
#ln /usr/bin/ld.gold
ln /usr/bin/nm
ln /usr/bin/objcopy
ln /usr/bin/objdump
ln /usr/bin/ranlib
ln /usr/bin/readelf
ln /usr/bin/size
ln /usr/bin/strings
ln /usr/bin/strip

ln /usr/bin/cc
ln /usr/bin/cpp
ln /usr/bin/c++

#pkg info -l llvm37 | grep usr/local/bin
