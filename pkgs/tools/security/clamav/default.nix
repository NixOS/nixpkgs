{ stdenv, fetchurl, fetchpatch, zlib, bzip2, libiconv, libxml2, openssl, ncurses, curl
, libmilter, pcre }:

stdenv.mkDerivation rec {
  name = "clamav-${version}";
  version = "0.99.2";

  src = fetchurl {
    url = "https://www.clamav.net/downloads/production/${name}.tar.gz";
    sha256 = "0yh2q318bnmf2152g2h1yvzgqbswn0wvbzb8p4kf7v057shxcyqn";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2017-6420.patch";
      url = "https://github.com/vrtadmin/clamav-devel/commit/dfc00cd3301a42b571454b51a6102eecf58407bc.patch";
      sha256 = "08w3p3a4pmi0cmcmyxkagsbn3g0jgx1jqlc34pn141x0qzrlqr60";
    })
  ];

  # don't install sample config files into the absolute sysconfdir folder
  postPatch = ''
    substituteInPlace Makefile.in --replace ' etc ' ' '
  '';

  buildInputs = [
    zlib bzip2 libxml2 openssl ncurses curl libiconv libmilter pcre
  ];

  configureFlags = [
    "--sysconfdir=/etc/clamav"
    "--with-zlib=${zlib.dev}"
    "--disable-zlib-vcheck" # it fails to recognize that 1.2.10 >= 1.2.2
    "--disable-llvm" # enabling breaks the build at the moment
    "--with-libbz2-prefix=${bzip2.dev}"
    "--with-iconv-dir=${libiconv}"
    "--with-xml=${libxml2.dev}"
    "--with-openssl=${openssl.dev}"
    "--with-libncurses-prefix=${ncurses.dev}"
    "--with-libcurl=${curl.dev}"
    "--with-pcre=${pcre.dev}"
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
    maintainers = with maintainers; [ phreedom robberer qknight ];
    platforms = platforms.linux;
  };
}
