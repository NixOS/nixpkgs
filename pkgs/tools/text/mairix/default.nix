{ stdenv, fetchurl, zlib, bzip2, bison, flex }:

stdenv.mkDerivation rec {
  name = "mairix-0.23";

  src = fetchurl {
    url = "mirror://sourceforge/mairix/${name}.tar.gz";
    sha256 = "1yzjpmsih6c60ks0d0ia153z9g35nj7dmk98383m0crw31dj6kl0";
  };

  buildInputs = [ zlib bzip2 bison flex ];

  # https://github.com/rc0/mairix/pull/19
  patches = [ ./mmap.patch ];

  enableParallelBuilding = true;

  meta = {
    homepage = http://www.rc0.org.uk/mairix;
    license = stdenv.lib.licenses.gpl2Plus;
    description = "Program for indexing and searching email messages stored in maildir, MH or mbox";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; all;
  };
}
