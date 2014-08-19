{stdenv, fetchurl, fuse, bison, flex_2_5_35, openssl, python, ncurses, readline,
 autoconf, automake, libtool, pkgconfig, zlib, libaio}:
let 
  s = # Generated upstream information 
  rec {
    baseName="glusterfs";
    version="3.5.2";
    name="${baseName}-${version}";
    hash="1hvns9islr5jcy0r1cw5890ra246y12pl5nlhl3bvmhglrkv8n7g";
    url="http://download.gluster.org/pub/gluster/glusterfs/3.5/3.5.2/glusterfs-3.5.2.tar.gz";
    sha256="1hvns9islr5jcy0r1cw5890ra246y12pl5nlhl3bvmhglrkv8n7g";
  };
  buildInputs = (stdenv.lib.optional (!stdenv.isSunOS) [fuse libaio]) ++ [
    bison flex_2_5_35 openssl python ncurses readline
    autoconf automake libtool pkgconfig zlib
  ];
in
stdenv.mkDerivation
rec {
  inherit (s) name version;
  inherit buildInputs;
  preConfigure = ''
    ./autogen.sh
  '' + stdenv.lib.optionalString stdenv.isSunOS ''
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

  configureFlags = [
    ''--with-mountutildir="$out/sbin"''
    (stdenv.lib.optionalString stdenv.isSunOS "--disable-fusermount")
    ];
  preInstall = ''
    substituteInPlace api/examples/Makefile --replace '$(DESTDIR)' $out
    substituteInPlace geo-replication/syncdaemon/Makefile --replace '$(DESTDIR)' $out
    substituteInPlace geo-replication/syncdaemon/Makefile --replace '$(DESTDIR)' $out
    substituteInPlace xlators/features/glupy/examples/Makefile --replace '$(DESTDIR)' $out
    substituteInPlace xlators/features/glupy/src/Makefile --replace '$(DESTDIR)' $out
    '';
  src = fetchurl {
    inherit (s) url sha256;
  };

  patches = stdenv.lib.optional stdenv.isSunOS [./disable-non-std-dir-testing.diff];

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
