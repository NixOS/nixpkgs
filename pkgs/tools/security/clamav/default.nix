{ stdenv, fetchurl, zlib, bzip2, libiconv, libxml2, openssl, ncurses, curl
, libmilter, pcre, freshclamConf ? null }:

stdenv.mkDerivation rec {
  name = "clamav-${version}";
  version = "0.99.2";

  src = fetchurl {
    url = "https://www.clamav.net/downloads/production/${name}.tar.gz";
    sha256 = "0yh2q318bnmf2152g2h1yvzgqbswn0wvbzb8p4kf7v057shxcyqn";
  };

  buildInputs = [ zlib bzip2 libxml2 openssl ncurses curl libiconv libmilter pcre ];

  configureFlags = [
    "--with-zlib=${zlib.dev}"
    "--with-libbz2-prefix=${bzip2.dev}"
    "--with-iconv-dir=${libiconv}"
    "--with-xml=${libxml2.dev}"
    "--with-openssl=${openssl.dev}"
    "--with-libncurses-prefix=${ncurses.dev}"
    "--with-libcurl=${curl.dev}"
    "--with-pcre=${pcre.dev}"
    "--enable-milter"
    "--disable-clamav"
  ];

  fixupPhase = if (freshclamConf != null) then ''echo "${freshclamConf}" > $out/etc/freshclam.conf'' else "";

  meta = with stdenv.lib; {
    homepage = http://www.clamav.net;
    description = "Antivirus engine designed for detecting Trojans, viruses, malware and other malicious threats";
    license = licenses.gpl2;
    maintainers = with maintainers; [ phreedom robberer qknight ];
    platforms = platforms.linux;
  };
}
