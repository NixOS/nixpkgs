{stdenv, fetchurl, fuse, bison, flex_2_5_35, openssl, python2, ncurses, readline,
 autoconf, automake, libtool, pkgconfig, zlib, libaio, libxml2, acl, sqlite
 , liburcu, attr, makeWrapper, coreutils, gnused, gnugrep, which
}:
let 
  s =
  rec {
    baseName="glusterfs";
    version = "3.10.1";
    name="${baseName}-${version}";
    url="http://download.gluster.org/pub/gluster/glusterfs/3.10/${version}/glusterfs-${version}.tar.gz";
    sha256 = "05qmn85lg3d1gz0fhn1v2z7nwl2qwbflvjc8nvkfyr4r57rkvhnk";
  };
  buildInputs = [
    fuse bison flex_2_5_35 openssl python2 ncurses readline
    autoconf automake libtool pkgconfig zlib libaio libxml2
    acl sqlite liburcu attr makeWrapper
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
    ''--localstatedir=/var''
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
    wrapProgram $out/sbin/mount.glusterfs --set PATH "${stdenv.lib.makeBinPath [ coreutils gnused attr gnugrep which]}"
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
