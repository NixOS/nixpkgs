{stdenv, fetchurl, fuse, bison, flex_2_5_35, openssl, python, ncurses, readline,
 autoconf, automake, libtool, pkgconfig, zlib, libaio}:
let 
  s = # Generated upstream information 
  rec {
    baseName="glusterfs";
    version="3.5.0";
    name="${baseName}-${version}";
    url="http://download.gluster.org/pub/gluster/glusterfs/3.5/3.5.0/glusterfs-3.5.0.tar.gz";
    sha256="0d9jlgxg19f2ajf5i4yw4f91n161rsi8fm95442ckci3xnz21zir";
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
