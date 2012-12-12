{stdenv, fetchurl, fuse, bison, flex, openssl, python, ncurses, readline}:
let 
  s = # Generated upstream information 
  rec {
    baseName="glusterfs";
    version="3.3.1";
    name="glusterfs-3.3.1";
    hash="06bmnyl3vh8s21kk98idm2fl7kq38na94k5l67l9l1grl3iyzahr";
    url="http://download.gluster.org/pub/gluster/glusterfs/3.3/3.3.1/glusterfs-3.3.1.tar.gz";
    sha256="06bmnyl3vh8s21kk98idm2fl7kq38na94k5l67l9l1grl3iyzahr";
  };
  buildInputs = [
    fuse bison flex openssl python ncurses readline
  ];
in
stdenv.mkDerivation
rec {
  inherit (s) name version;
  inherit buildInputs;
  configureFlags = [
    ''--with-mountutildir="$out/sbin"''
    ];
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
