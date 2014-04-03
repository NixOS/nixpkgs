{stdenv, fetchurl, fuse, bison, flex, openssl, python, ncurses, readline}:
let 
  s = # Generated upstream information 
  rec {
    baseName="glusterfs";
    version="3.4.3";
    name="${baseName}-${version}";
    hash="1vzdihsy4da11jsa46n1n2xk6d40g7v0zrlqvs3pb9k07fql5kag";
    url="http://download.gluster.org/pub/gluster/glusterfs/3.4/${version}/glusterfs-${version}.tar.gz";
    sha256="0j1yvpdb1bydsh3pqlyr23mfvra5bap9rxba910s9cn61mpy99bj";
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
      linux ++ freebsd ++ illumos;
  };
}
