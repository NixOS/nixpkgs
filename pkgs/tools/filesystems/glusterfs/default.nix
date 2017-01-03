{stdenv, fetchurl, fuse, bison, flex_2_5_35, openssl, python2, ncurses, readline,
 autoconf, automake, libtool, pkgconfig, zlib, libaio, libxml2, acl, sqlite
 , liburcu, attr
}:
let 
  s = # Generated upstream information 
  rec {
    baseName="glusterfs";
    version="3.9.0";
    name="${baseName}-${version}";
    hash="057vq4f93f1g9sh1sfbqhccsprxrbhwwm898322x25sb8mscc5xl";
    url="http://download.gluster.org/pub/gluster/glusterfs/3.9/3.9.0/glusterfs-3.9.0.tar.gz";
    sha256="057vq4f93f1g9sh1sfbqhccsprxrbhwwm898322x25sb8mscc5xl";
  };
  buildInputs = [
    fuse bison flex_2_5_35 openssl python2 ncurses readline
    autoconf automake libtool pkgconfig zlib libaio libxml2
    acl sqlite liburcu attr
  ];
  # Some of the headers reference acl
  propagatedBuildInputs = [
    acl
  ];
in
stdenv.mkDerivation
rec {
  inherit (s) name version;
  inherit buildInputs propagatedBuildInputs;

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
