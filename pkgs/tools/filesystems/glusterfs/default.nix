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
    url="https://github.com/gluster/glusterfs/archive/v${version}.tar.gz";
    sha256 = "0gmb3m98djljcycjggi1qv99ai6k4cvn2rqym2q9f58q8n8kdhh7";
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

   # Note that the VERSION file is something that is present in release tarballs
   # but not in git tags (at least not as of writing in v3.10.1).
   # That's why we have to create it.
   # Without this, gluster (at least 3.10.1) will fail very late and cryptically,
   # for example when setting up geo-replication, with a message like
   #   Staging of operation 'Volume Geo-replication Create' failed on localhost : Unable to fetch master volume details. Please check the master cluster and master volume.
   # What happens here is that the gverify.sh script tries to compare the versions,
   # but fails when the version is empty.
   # See upstream GlusterFS bug https://bugzilla.redhat.com/show_bug.cgi?id=1452705
   preConfigure = ''
     echo "v${s.version}" > VERSION
    ./autogen.sh
    '';

  configureFlags = [
    ''--localstatedir=/var''
    ];

  makeFlags = "DESTDIR=$(out)";

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
