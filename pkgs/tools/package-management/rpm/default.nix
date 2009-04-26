{stdenv, fetchurl, cpio, zlib, bzip2, file, sqlite, beecrypt, neon, elfutils}:

stdenv.mkDerivation {
  name = "rpm-4.4.8";

  src = fetchurl {
    url = http://wraptastic.org/pub/rpm-4.4.x/rpm-4.4.8.tar.gz;
    sha256 = "02ddf076bwcpxzxq9i0ii1fzw2r69fk0gjkk2yrzgzsmb01na230";
  };

  # Note: we don't add elfutils to buildInputs, since it provides a
  # bad `ld' and other stuff.
  buildInputs = [cpio zlib bzip2 file sqlite beecrypt neon];

  NIX_CFLAGS_COMPILE = "-I${beecrypt}/include/beecrypt -I${neon}/include/neon -I${elfutils}/include";

  NIX_CFLAGS_LINK = "-L${elfutils}/lib";

  preConfigure = ''
    rm -rf zlib file sqlite

    substituteInPlace ./installplatform --replace /usr/bin/env $(type -tp env)
    substituteInPlace Makefile.in --replace /var/tmp $(pwd)/dummy
  '';

  dontDisableStatic = true;

  configureFlags = "--without-selinux --without-lua --without-python --without-perl";

  patches = [./no-lua.patch];
}
