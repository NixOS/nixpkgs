source $stdenv/setup

prefix=$out
export prefix

installFlags="BINDIR=$out/sbin MANDIR=$out/share/man INSTALL=install"
patchPhase="sed -e 's@-o \${MAN_USER} -g \${MAN_GROUP} -m \${MAN_PERMS} @@' -i Makefile"

mkdir -p "$out/share/man/man8/"
mkdir -p "$out/share/man/man5/"
mkdir -p "$out/sbin"

genericBuild
