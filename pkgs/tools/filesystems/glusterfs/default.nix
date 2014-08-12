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
  buildInputs = [
    fuse bison flex_2_5_35 openssl python ncurses readline
    autoconf automake libtool pkgconfig zlib libaio
  ];
in
stdenv.mkDerivation
rec {
  inherit (s) name version;
  inherit buildInputs;
  preConfigure = ''
    ./autogen.sh
    '';
  configureFlags = [
    ''--with-mountutildir="$out/sbin"''
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
