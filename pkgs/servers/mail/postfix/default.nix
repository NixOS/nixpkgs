{stdenv, fetchurl, db4, glibc}:

stdenv.mkDerivation {
  name = "postfix-2.2.11";
  src = fetchurl {
    url = ftp://ftp.cs.uu.nl/mirror/postfix/postfix-release/official/postfix-2.2.11.tar.gz;
    sha256 = "04hxpyd3h1f48fnppjwqqxbil13bcwidzpfkra2pgm7h42d9blq7";
  };

  buildinputs = [db4];
  patches = [./postfix-2.2.9-db.patch ./postfix-2.2.9-lib.patch];
  inherit glibc;
}
