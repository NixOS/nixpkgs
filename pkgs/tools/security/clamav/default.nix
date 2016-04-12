{ stdenv, fetchurl, zlib, bzip2, libiconv, libxml2, openssl, ncurses, curl
, libmilter, pcre, freshclamConf ? null }:

stdenv.mkDerivation rec {
  name = "clamav-${version}";
  version = "0.99.1";

  src = fetchurl {
    url = "mirror://sourceforge/clamav/clamav-${version}.tar.gz";
    sha256 = "12nm4mxzx3qlbm65cadflzncjfkxdfqcp0lch29i5yfk4a8nhi71";
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

  fixupPhase = if (freshclamConf != null) then ''echo "${freshclamConf}" > $out/etc/freshclam.conf'' else "";

  meta = with stdenv.lib; {
    homepage = http://www.clamav.net;
    description = "Antivirus engine designed for detecting Trojans, viruses, malware and other malicious threats";
    license = licenses.gpl2;
    maintainers = with maintainers; [ phreedom robberer qknight ];
    platforms = platforms.linux;
  };
}
