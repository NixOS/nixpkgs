{ stdenv, fetchurl, zlib, bzip2, libiconvOrNull, libxml2, openssl, ncurses, curl }:
stdenv.mkDerivation rec {
  name = "clamav-${version}";
  version = "0.98.5";

  src = fetchurl {
    url = "mirror://sourceforge/clamav/clamav-${version}.tar.gz";
    sha256 = "0kdaimnbbb0hymg7d15a3iwk17r8555nyzr3d1j96cwhzbakfbww";
  };

  buildInputs = [ zlib bzip2 libxml2 openssl ncurses curl ]
    ++ stdenv.lib.optional (libiconvOrNull != null) libiconvOrNull;

  configureFlags = [
    "--with-zlib=${zlib}"
    "--with-libbz2-prefix=${bzip2}"
  ] ++ (stdenv.lib.optional (libiconvOrNull != null)
       "--with-iconv-dir=${libiconvOrNull}")
  ++ [
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
