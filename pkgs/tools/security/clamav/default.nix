{ stdenv, fetchurl, zlib, bzip2, libiconv, libxml2, openssl, ncurses, curl
, libmilter, pcre }:
stdenv.mkDerivation rec {
  name = "clamav-${version}";
  version = "0.99";

  src = fetchurl {
    url = "mirror://sourceforge/clamav/clamav-${version}.tar.gz";
    sha256 = "1abyg349yr31z764jcgx67q5v098jrkrj88bqkzmys6xza62qyfj";
  };

  buildInputs = [ zlib bzip2 libxml2 openssl ncurses curl libiconv libmilter pcre ];

  configureFlags = [
    "--with-zlib=${zlib}"
    "--with-libbz2-prefix=${bzip2}"
    "--with-iconv-dir=${libiconv}"
    "--with-xml=${libxml2}"
    "--with-openssl=${openssl}"
    "--with-libncurses-prefix=${ncurses}"
    "--with-libcurl=${curl}"
    "--with-pcre=${pcre}"
    "--enable-milter"
    "--disable-clamav"
  ];

  meta = with stdenv.lib; {
    homepage = http://www.clamav.net;
    description = "Antivirus engine designed for detecting Trojans, viruses, malware and other malicious threats";
    license = licenses.gpl2;
    maintainers = with maintainers; [ phreedom robberer qknight ];
    platforms = platforms.linux;
  };
}
