source "$stdenv/setup" || exit 1

# Unpack
unpackPhase &&							\
cd "$sourceRoot/upstream/tarballs" &&				\
tar xzvf * &&							\
cd tcp_wrappers_7.6 &&						\
								\
# Patch
substituteInPlace "Makefile" --replace				\
   "REAL_DAEMON_DIR=/usr/sbin" "REAL_DAEMON_DIR=$out/sbin"	\
   --replace "/tmp" '$$TMPDIR' &&				\
substituteInPlace "scaffold.c" --replace			\
   'extern char *malloc();' " " &&				\
substituteInPlace "environ.c" --replace				\
   'extern char *malloc();' " " &&				\
								\
# The `linux' target doesn't work on Linux...
echo building... &&						\
make REAL_DAEMON_DIR="$out/sbin" freebsd &&			\
								\
# Install
ensureDir "$out/sbin" &&					\
cp safe_finger tcpd tcpdchk tcpdmatch try-from "$out/sbin" &&	\
								\
ensureDir "$out/lib" &&						\
cp lib*.a "$out/lib" &&						\
								\
ensureDir "$out/include" &&					\
cp *.h "$out/include" && 					\
								\
ensureDir "$out/man" &&						\
for i in 3 5 8;							\
do								\
  ensureDir "$out/man/man$i" &&					\
  cp *.$i "$out/man/man$i" ;					\
done								\
