{stdenv, fetchurl, fuse, bison, flex_2_5_35, openssl, python, ncurses, readline,
 autoconf, automake, libtool, pkgconfig, zlib, libaio, libxml2}:
let 
  s = # Generated upstream information 
  rec {
    baseName="glusterfs";
    version="3.6.3";
    name="${baseName}-${version}";
    hash="084zkc1jd5ggkfl0f5d4s7lra5xgildnphyf6ywzxrb7g44vk0d4";
    url="http://download.gluster.org/pub/gluster/glusterfs/3.6/3.6.3/glusterfs-3.6.3.tar.gz";
    sha256="084zkc1jd5ggkfl0f5d4s7lra5xgildnphyf6ywzxrb7g44vk0d4";
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
    ''--with-mountutildir="$out/sbin" --localstatedir=/var''
    ];

  makeFlags = "DESTDIR=$(out)";

  preInstall = ''
    substituteInPlace api/examples/Makefile --replace '$(DESTDIR)' $out
    substituteInPlace geo-replication/syncdaemon/Makefile --replace '$(DESTDIR)' $out
    substituteInPlace geo-replication/syncdaemon/Makefile --replace '$(DESTDIR)' $out
    substituteInPlace xlators/features/glupy/examples/Makefile --replace '$(DESTDIR)' $out
    substituteInPlace xlators/features/glupy/src/Makefile --replace '$(DESTDIR)' $out
    '';

  postInstall = ''
    cp -r $out/$out/* $out
    rm -r $out/nix
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
