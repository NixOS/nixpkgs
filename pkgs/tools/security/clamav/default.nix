{ stdenv, fetchurl, zlib, bzip2, libiconv, libxml2, openssl, ncurses, curl }:
stdenv.mkDerivation rec {
  name = "clamav-${version}";
  version = "0.98.6";

  src = fetchurl {
    url = "mirror://sourceforge/clamav/clamav-${version}.tar.gz";
    sha256 = "0l99a0shgzpl8rvrrgbm1ki2zxlb7g1n82bhq7f2snj4amfj94b5";
  };

  buildInputs = [ zlib bzip2 libxml2 openssl ncurses curl libiconv ];

  configureFlags = [
    "--with-zlib=${zlib}"
    "--with-libbz2-prefix=${bzip2}"
    "--with-iconv-dir=${libiconv}"
    "--with-xml=${libxml2}"
    "--with-openssl=${openssl}"
    "--with-libncurses-prefix=${ncurses}"
    "--with-libcurl=${curl}"
    "--disable-clamav"
  ];

  meta = with stdenv.lib; {
    homepage = http://www.clamav.net;
    description = "Antivirus engine designed for detecting Trojans, viruses, malware and other malicious threats";
    license = licenses.gpl2;
    maintainers = [ maintainers.phreedom maintainers.robberer ];
    platforms = platforms.linux;
  };
}
