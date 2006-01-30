{stdenv, fetchurl, ps, ncurses, zlib ? null, perl}:

# Note: zlib is not required; MySQL can use an internal zlib.

stdenv.mkDerivation {
  name = "mysql-4.1.16";

  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/mysql-4.1.16.tar.gz;
    md5 = "13c5fdd05e28863db3a1261635890b5f";
  };

  buildInputs = [ps ncurses zlib perl];
}
