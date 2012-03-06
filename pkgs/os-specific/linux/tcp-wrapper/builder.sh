source "$stdenv/setup" || exit 1

# Unpack
unpackPhase
cd "$sourceRoot/upstream/tarballs"
tar xzvf *
cd tcp_wrappers_7.6

# Patch
patchPhase
for patch in debian/patches/*
do
  echo "applying Debian patch \`$(basename $patch)'..."
  patch --batch -p1 < $patch
done

substituteInPlace "Makefile" --replace				\
   "REAL_DAEMON_DIR=/usr/sbin" "REAL_DAEMON_DIR=$out/sbin"	\
   --replace "/tmp" '$$TMPDIR'

echo "building..."
make REAL_DAEMON_DIR="$out/sbin" linux

# Install
mkdir -p "$out/sbin"
cp -v safe_finger tcpd tcpdchk tcpdmatch try-from "$out/sbin"

mkdir -p "$out/lib"
cp -v shared/lib*.so* "$out/lib"

mkdir -p "$out/include"
cp -v *.h "$out/include"

mkdir -p "$out/man"
for i in 3 5 8;
do
  mkdir -p "$out/man/man$i"
  cp *.$i "$out/man/man$i" ;
done
