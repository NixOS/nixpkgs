{ stdenv, fetchurl, pkgconfig
, zlib, bzip2, libiconv, libxml2, openssl, ncurses, curl, libmilter, pcre2
, libmspack, systemd
}:

stdenv.mkDerivation rec {
  name = "clamav-${version}";
  version = "0.100.2";

  src = fetchurl {
    url = "https://www.clamav.net/downloads/production/${name}.tar.gz";
    sha256 = "1mkd41sxbjkfjinpx5b9kb85q529gj2s3d0klysssqhysh64ybja";
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
    maintainers = with maintainers; [ phreedom robberer qknight fpletz ];
    platforms = platforms.linux;
  };
}
