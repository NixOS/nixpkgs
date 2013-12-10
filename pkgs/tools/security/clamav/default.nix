{ stdenv, fetchurl, zlib, bzip2, libiconv }:
stdenv.mkDerivation rec {
  name = "clamav-${version}";
  version = "0.98";

  src = fetchurl {
    url = "mirror://sourceforge/clamav/clamav-${version}.tar.gz";
    sha256 = "1dmkaa6sqynv4v74s9izq7m7kk8d78rvwyd123q4gva6gx9m0d0i";
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
