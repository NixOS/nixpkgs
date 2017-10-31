{stdenv, fetchurl, bzip2}:

stdenv.mkDerivation {
  name = "rzip-2.1";
  src = fetchurl {
    url = mirror://samba/rzip/rzip-2.1.tar.gz;
    sha256 = "4bb96f4d58ccf16749ed3f836957ce97dbcff3e3ee5fd50266229a48f89815b7";
  };
  buildInputs = [ bzip2 ];

  meta = {
    homepage = http://rzip.samba.org/;
    description = "Compression program";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.unix;
  };
}
