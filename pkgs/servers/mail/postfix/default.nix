{stdenv, fetchurl, db4, glibc}:

stdenv.mkDerivation {
  name = "postfix-2.2.9";
  src = fetchurl {
    url = ftp://ftp.cs.uu.nl/mirror/postfix/postfix-release/official/postfix-2.2.9.tar.gz;
    md5 = "be78631bd9b6bf7735e43abfa54d69f6";
  };

  buildinputs = [db4];
  patches = [./postfix-2.2.9-db.patch ./postfix-2.2.9-lib.patch];
  inherit glibc;
}
