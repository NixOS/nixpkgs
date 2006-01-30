{stdenv, fetchurl, e2fsprogs, ncurses, readline}:

stdenv.mkDerivation {
  name = "parted-1.6.23";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/parted-1.6.23.tar.gz;
    md5 = "7e46a32def60ea355c193d9225691742";
  };
  buildInputs = [e2fsprogs ncurses readline];
  patches = [./parted-trailingcomma.patch];
}
