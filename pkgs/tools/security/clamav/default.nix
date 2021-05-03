{ stdenv, fetchurl, fetchpatch, pkgconfig
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

  patches = [
    (fetchpatch {
      name = "CVE-2021-1405.patch";
      url = "https://github.com/Cisco-Talos/clamav-devel/commit/0c1ec30f9a292b0a5eca4aaaa651150aa5712d6d.patch";
      sha256 = "0ygqiv9ldwhhnlwxkz91bab4hnzfwczf96mqm1bsa4gz9wmshlks";
    })
  ];

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
