{ stdenv, fetchurl, pkg-config
, zlib, bzip2, libiconv, libxml2, openssl, ncurses, curl, libmilter, pcre2
, libmspack, systemd, Foundation, json_c, check
}:

stdenv.mkDerivation rec {
  pname = "clamav";
  version = "0.103.0";

  src = fetchurl {
    url = "https://www.clamav.net/downloads/production/${pname}-${version}.tar.gz";
    sha256 = "0ih5x1rscg2m64y0z20njj7435q8k7ss575cfw7aipdzfx979a9j";
  };

  # don't install sample config files into the absolute sysconfdir folder
  postPatch = ''
    substituteInPlace Makefile.in --replace ' etc ' ' '
  '';

  enableParallelBuilding = true;
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    zlib bzip2 libxml2 openssl ncurses curl libiconv libmilter pcre2 libmspack json_c check
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
    "--with-libjson=${json_c.dev}"
    "--with-system-libmspack"
    "--enable-milter"
    "--disable-unrar" # disable unrar because it's non-free and requires some extra patching to work properly
    "--enable-check"
  ] ++ stdenv.lib.optional stdenv.isLinux
    "--with-systemdsystemunitdir=$(out)/lib/systemd";

  postInstall = ''
    mkdir $out/etc
    cp etc/*.sample $out/etc
  '';

  # Only required for the unit tests
  hardeningDisable = [ "format" ];
  doCheck = true;

  meta = with stdenv.lib; {
    homepage = "https://www.clamav.net";
    description = "Antivirus engine designed for detecting Trojans, viruses, malware and other malicious threats";
    license = licenses.gpl2;
    maintainers = with maintainers; [ phreedom robberer qknight fpletz globin ];
    platforms = platforms.unix;
  };
}
