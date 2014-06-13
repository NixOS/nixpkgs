{stdenv, fetchurl, fuse, bison, flex, openssl, python, ncurses, readline}:
let 
  s = # Generated upstream information 
  rec {
    baseName="glusterfs";
    version="3.4.3";
    name="${baseName}-${version}";
    hash="1vzdihsy4da11jsa46n1n2xk6d40g7v0zrlqvs3pb9k07fql5kag";
    url="http://download.gluster.org/pub/gluster/glusterfs/3.4/3.4.3/glusterfs-3.4.3.tar.gz";
    sha256="0j1yvpdb1bydsh3pqlyr23mfvra5bap9rxba910s9cn61mpy99bj";
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
