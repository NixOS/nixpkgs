{ stdenv, fetchurl, pkgconfig
, zlib, bzip2, libiconv, libxml2, openssl, ncurses, curl, libmilter, pcre2
, libmspack, systemd, Foundation
}:

stdenv.mkDerivation rec {
  pname = "clamav";
  version = "0.102.4";

  src = fetchurl {
    url = "https://www.clamav.net/downloads/production/${pname}-${version}.tar.gz";
    sha256 = "06rrzyrhnr0rswryijpbbzywr6387rv8qjq8sb8cl3h2d1m45ggf";
  };

  # don't install sample config files into the absolute sysconfdir folder
  postPatch = ''
    substituteInPlace Makefile.in --replace ' etc ' ' '
  '';

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    zlib bzip2 libxml2 openssl ncurses curl libiconv libmilter pcre2 libmspack
  ] ++ stdenv.lib.optional stdenv.isLinux systemd
    ++ stdenv.lib.optional stdenv.isDarwin Foundation;

  configureFlags = [
    "--libdir=$(out)/lib"
    "--sysconfdir=/etc/clamav"
    "--disable-llvm" # enabling breaks the build at the moment
    "--with-zlib=${zlib.dev}"
    "--with-xml=${libxml2.dev}"
    "--with-openssl=${openssl.dev}"
    "--with-libcurl=${curl.dev}"
    "--with-system-libmspack"
    "--enable-milter"
  ] ++ stdenv.lib.optional stdenv.isLinux
    "--with-systemdsystemunitdir=$(out)/lib/systemd";

  postInstall = ''
    mkdir $out/etc
    cp etc/*.sample $out/etc
  '';

  meta = with stdenv.lib; {
    homepage = "https://www.clamav.net";
    description = "Antivirus engine designed for detecting Trojans, viruses, malware and other malicious threats";
    license = licenses.gpl2;
    maintainers = with maintainers; [ phreedom robberer qknight fpletz globin ];
    platforms = platforms.unix;
  };
}
