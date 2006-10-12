{stdenv, fetchurl, ps, ncurses, zlib ? null, perl}:

# Note: zlib is not required; MySQL can use an internal zlib.

stdenv.mkDerivation {
  name = "mysql-4.1.18";

  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/mysql-4.1.18.tar.gz;
    md5 = "a2db4edb3e1e3b8e0f8c2242225ea513";
  };

  buildInputs = [ps ncurses zlib perl];

  configureFlags = "--enable-thread-safe-client";
}
