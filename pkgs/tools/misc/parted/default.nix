{stdenv, fetchurl, e2fsprogs}:

stdenv.mkDerivation {
  name = "parted-1.6.23";
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/gnu/parted/parted-1.6.23.tar.gz;
    md5 = "7e46a32def60ea355c193d9225691742";
  };
  buildInputs = [e2fsprogs];
}
