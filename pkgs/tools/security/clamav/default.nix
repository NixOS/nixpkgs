{ stdenv, fetchurl, zlib, bzip2, libiconv }:
stdenv.mkDerivation rec {
  name = "clamav-${version}";
  version = "0.97.5";

  src = fetchurl {
    url = "mirror://sourceforge/clamav/clamav-${version}.tar.gz";
    sha256 = "039wm64wl2sx7k019g5ll5dkdlsq64fnd0ng0s00pjn8bqd5wv6v";
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
