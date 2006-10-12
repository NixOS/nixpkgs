{stdenv, fetchurl, e2fsprogs, ncurses, readline}:

stdenv.mkDerivation {
  name = "parted-1.7.1";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/parted-1.7.1.tar.bz2;
    md5 = "baa6771273c8362d735086d52a0d6efe";
  };
  buildInputs = [e2fsprogs ncurses readline];
  patches = [./parted-trailingcomma.patch];
}
