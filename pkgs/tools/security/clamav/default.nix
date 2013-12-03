{ stdenv, fetchurl, zlib, bzip2, libiconv }:
stdenv.mkDerivation rec {
  name = "clamav-${version}";
  version = "0.97.8";

  src = fetchurl {
    url = "mirror://sourceforge/clamav/clamav-${version}.tar.gz";
    sha256 = "04pwm8a84silnvgimn2wi2wgwdzwpskybx72mp10ni1dd7yvswnq";
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
