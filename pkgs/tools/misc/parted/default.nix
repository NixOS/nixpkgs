{stdenv, fetchurl, e2fsprogs, ncurses, readline}:

stdenv.mkDerivation {
  name = "parted-1.8.1";
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/gnu/parted/parted-1.8.1.tar.bz2;
    md5 = "c430b38fd5f3c7530e2c3a3bdf605a29";
  };
  buildInputs = [e2fsprogs ncurses readline];
  patches = [./parted-trailingcomma.patch];
}
