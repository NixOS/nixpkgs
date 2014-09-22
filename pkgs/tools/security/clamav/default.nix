{ stdenv, fetchurl, zlib, bzip2, libiconv, libxml2, openssl, ncurses, curl }:
stdenv.mkDerivation rec {
  name = "clamav-${version}";
  version = "0.98.4";

  src = fetchurl {
    url = "mirror://sourceforge/clamav/clamav-${version}.tar.gz";
    sha256 = "071yzamalj3rf7kl2jvc35ipnk1imdkq5ylbb8whyxfgmd3nf06k";
  };

  buildInputs = [ zlib bzip2 libiconv libxml2 openssl ncurses curl ];

  configureFlags = [
    "--with-zlib=${zlib}"
    "--with-libbz2-prefix=${bzip2}"
    "--with-iconv-dir=${libiconv}"
    "--with-xml=${libxml2}"
    "--with-openssl=${openssl}"
    "--with-libncurses-prefix=${ncurses}"
    "--with-libcurl=${curl}"
    "--disable-clamav" ];

  meta = with stdenv.lib; {
    homepage = http://www.clamav.net;
    description = "Antivirus engine designed for detecting Trojans, viruses, malware and other malicious threats";
    license = licenses.gpl2;
    maintainers = [ maintainers.phreedom maintainers.robberer ];
    platforms = platforms.linux;
  };
}
