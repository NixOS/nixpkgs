{stdenv, fetchurl, fuse, bison, flex_2_5_35, openssl, python, ncurses, readline,
 autoconf, automake, libtool, pkgconfig, zlib, libaio, libxml2, acl, sqlite
 , liburcu, attr
}:
let 
  s = # Generated upstream information 
  rec {
    baseName="glusterfs";
    version="3.7.1";
    name="${baseName}-${version}";
    hash="0d1bcijwvc3rhr24xsn7nnp0b5xwlwvybamb05jzja5m7hapydpw";
    url="http://download.gluster.org/pub/gluster/glusterfs/3.7/3.7.1/glusterfs-3.7.1.tar.gz";
    sha256="0d1bcijwvc3rhr24xsn7nnp0b5xwlwvybamb05jzja5m7hapydpw";
  };
  buildInputs = [
    fuse bison flex_2_5_35 openssl python ncurses readline
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
