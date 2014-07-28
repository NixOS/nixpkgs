{stdenv, fetchurl, bzip2}:

stdenv.mkDerivation {
  name = "rzip-2.1";
  src = fetchurl {
    url = http://rzip.samba.org/ftp/rzip/rzip-2.1.tar.gz;
    sha256 = "4bb96f4d58ccf16749ed3f836957ce97dbcff3e3ee5fd50266229a48f89815b7";
  };
  buildInputs = [ bzip2 ];

  meta = {
    homepage = http://rzip.samba.org/;
    description = "The RZIP compression program";
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
