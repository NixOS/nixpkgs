{ stdenv, fetchurl, pkgconfig
, zlib, bzip2, libiconv, libxml2, openssl, ncurses, curl, libmilter, pcre2
, libmspack, systemd
}:

stdenv.mkDerivation rec {
  name = "clamav-${version}";
  version = "0.101.3";

  src = fetchurl {
    url = "https://www.clamav.net/downloads/production/${name}.tar.gz";
    sha256 = "0f034sqqgngj3ry71f7j73g66n6mqfisjcw5529y5gcw9an2mm38";
  };

  # don't install sample config files into the absolute sysconfdir folder
  postPatch = ''
    substituteInPlace Makefile.in --replace ' etc ' ' '
  '';

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    zlib bzip2 libxml2 openssl ncurses curl libiconv libmilter pcre2 libmspack
    systemd
  ];

  configureFlags = [
    "--libdir=$(out)/lib"
    "--sysconfdir=/etc/clamav"
    "--with-systemdsystemunitdir=$(out)/lib/systemd"
    "--disable-llvm" # enabling breaks the build at the moment
    "--with-zlib=${zlib.dev}"
    "--with-xml=${libxml2.dev}"
    "--with-openssl=${openssl.dev}"
    "--with-libcurl=${curl.dev}"
    "--with-system-libmspack"
    "--enable-milter"
  ];

  postInstall = ''
    mkdir $out/etc
    cp etc/*.sample $out/etc
  '';

  meta = with stdenv.lib; {
    homepage = https://www.clamav.net;
    description = "Antivirus engine designed for detecting Trojans, viruses, malware and other malicious threats";
    license = licenses.gpl2;
    maintainers = with maintainers; [ phreedom robberer qknight fpletz globin ];
    platforms = platforms.linux;
  };
}
