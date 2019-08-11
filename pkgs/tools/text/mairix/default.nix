{ stdenv, fetchurl, zlib, bzip2, bison, flex }:

stdenv.mkDerivation rec {
  name = "mairix-0.24";

  src = fetchurl {
    url = "mirror://sourceforge/mairix/${name}.tar.gz";
    sha256 = "0msaxz5c5hf7k1ci16i67m4ynrbrpsxbqzk84nz6z2vnkh3jww50";
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
