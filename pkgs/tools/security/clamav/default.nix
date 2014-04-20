{ stdenv, fetchurl, zlib, bzip2, libiconv }:
stdenv.mkDerivation rec {
  name = "clamav-${version}";
  version = "0.98.1";

  src = fetchurl {
    url = "mirror://sourceforge/clamav/clamav-${version}.tar.gz";
    sha256 = "1p13n8g3b88cxwxj07if9z1d2cav1ib94v6cq4r4bpacfd6yix9m";
  };

  buildInputs = [ zlib bzip2 libiconv ];

  configureFlags = [
    "--with-zlib=${zlib}"
    "--with-libbz2-prefix=${bzip2}"
    "--with-iconv-dir=${libiconv}"
    "--disable-clamav" ];

  meta = with stdenv.lib; {
    homepage = http://www.clamav.net;
    description = "Antivirus engine designed for detecting Trojans, viruses, malware and other malicious threats";
    license = licenses.gpl2;
    maintainers = [ maintainers.phreedom ];
    platforms = platforms.linux;
  };
}
