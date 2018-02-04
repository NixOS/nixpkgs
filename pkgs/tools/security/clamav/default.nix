{ stdenv, fetchurl, fetchpatch, pkgconfig
, zlib, bzip2, libiconv, libxml2, openssl, ncurses, curl, libmilter, pcre
}:

stdenv.mkDerivation rec {
  name = "clamav-${version}";
  version = "0.99.3";

  src = fetchurl {
    url = "https://www.clamav.net/downloads/production/${name}.tar.gz";
    sha256 = "114f7qk3h0klgm0zzn2394n5spcn91vjc9mq6m03l2p0ls955yh0";
  };

  # don't install sample config files into the absolute sysconfdir folder
  postPatch = ''
    substituteInPlace Makefile.in --replace ' etc ' ' '
  '';

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    zlib bzip2 libxml2 openssl ncurses curl libiconv libmilter pcre
  ];

  patches = [ ./fd-leak.patch ];

  configureFlags = [
    "--sysconfdir=/etc/clamav"
    "--disable-llvm" # enabling breaks the build at the moment
    "--with-zlib=${zlib.dev}"
    "--with-xml=${libxml2.dev}"
    "--with-openssl=${openssl.dev}"
    "--with-libcurl=${curl.dev}"
    "--enable-milter"
  ];

  postInstall = ''
    mkdir $out/etc
    cp etc/*.sample $out/etc
  '';

  meta = with stdenv.lib; {
    homepage = http://www.clamav.net;
    description = "Antivirus engine designed for detecting Trojans, viruses, malware and other malicious threats";
    license = licenses.gpl2;
    maintainers = with maintainers; [ phreedom robberer qknight fpletz ];
    platforms = platforms.linux;
  };
}
