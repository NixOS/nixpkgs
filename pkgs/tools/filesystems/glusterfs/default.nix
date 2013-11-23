{stdenv, fetchurl, fuse, bison, flex, openssl, python, ncurses, readline}:
let 
  s = # Generated upstream information 
  rec {
    baseName="glusterfs";
    version="3.4.1";
    name="${baseName}-${version}";
    hash="0fdp3bifd7n20xlmsmj374pbp11k7np71f7ibzycsvmqqviv9wdm";
    url="http://download.gluster.org/pub/gluster/glusterfs/3.4/3.4.1/glusterfs-3.4.1.tar.gz";
    sha256="0fdp3bifd7n20xlmsmj374pbp11k7np71f7ibzycsvmqqviv9wdm";
  };
  buildInputs = (stdenv.lib.optional (!stdenv.isSunOS) [fuse]) ++ [
    bison flex openssl python ncurses readline
  ];
in
stdenv.mkDerivation
rec {
  inherit (s) name version;
  inherit buildInputs;
  configureFlags = [
    ''--with-mountutildir="$out/sbin"''
    (stdenv.lib.optionalString stdenv.isSunOS "--disable-fusermount")
    ];
  src = fetchurl {
    inherit (s) url sha256;
  };

  patches = stdenv.lib.optional stdenv.isSunOS [./disable-non-std-dir-testing.diff];

  preConfigure = stdenv.lib.optionalString stdenv.isSunOS ''
    find . -name \*.c -or -name \*.h -exec sed -i \
      -e 's|\su_int| uint|g'\
      -e 's|<sys/cdefs.h>|<sys/types.h>|g' {} \;

    mv ./api/src/glfs.h ./api/src/glfs.h.orig
    cat > ./api/src/glfs.h <<-EOF
      #ifdef        __cplusplus
      # define __BEGIN_DECLS  extern "C" {
      # define __END_DECLS    }
      #else
      # define __BEGIN_DECLS
      # define __END_DECLS
      #endif
    EOF
    cat ./api/src/glfs.h.orig >> ./api/src/glfs.h
  '';

  meta = {
    inherit (s) version;
    description = "Distributed storage system";
    maintainers = [
      stdenv.lib.maintainers.raskin
    ];
    platforms = with stdenv.lib.platforms; 
      linux ++ freebsd;
  };
}
