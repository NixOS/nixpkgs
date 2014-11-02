{stdenv, fetchurl, fuse, bison, flex_2_5_35, openssl, python, ncurses, readline,
 autoconf, automake, libtool, pkgconfig, zlib, libaio, libxml2}:
let 
  s = # Generated upstream information 
  rec {
    baseName="glusterfs";
    version="3.6.0";
    name="${baseName}-${version}";
    hash="1c4lscqc5kvn5yj5pspvml59n1czspfqqdwhz73hbjd5lbqak9ml";
    url="http://download.gluster.org/pub/gluster/glusterfs/3.6/3.6.0/glusterfs-3.6.0.tar.gz";
    sha256="1c4lscqc5kvn5yj5pspvml59n1czspfqqdwhz73hbjd5lbqak9ml";
  };
  buildInputs = [
    fuse bison flex_2_5_35 openssl python ncurses readline
    autoconf automake libtool pkgconfig zlib libaio libxml2
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
