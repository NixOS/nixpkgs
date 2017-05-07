{ stdenv, fetchurl, fetchpatch, autoreconfHook, pkgconfig, zlib, bzip2, libiconv, libxml2
, openssl, ncurses, curl, libmilter, pcre }:

stdenv.mkDerivation rec {
  name = "clamav-${version}";
  version = "0.99.2";

  src = fetchurl {
    url = "https://www.clamav.net/downloads/production/${name}.tar.gz";
    sha256 = "0yh2q318bnmf2152g2h1yvzgqbswn0wvbzb8p4kf7v057shxcyqn";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [
    zlib bzip2 libxml2 openssl ncurses curl libiconv libmilter pcre
  ];

  patches = [
    # autoreconfHook can be removed as soon as this is in a released version
    (fetchpatch {
      url = "https://github.com/vrtadmin/clamav-devel/commit/fa15aa98c7d5e1d8fc22e818ebd089f2e53ebe1d.patch";
      sha256 = "062q8ls6wvghh43qci58xgcv8gnagwxxnxic7jcz9r9fg1fva90l";
    })
  ];

  # don't install sample config files into the absolute sysconfdir folder
  postPatch = ''
    substituteInPlace Makefile.in --replace ' etc ' ' '
  '';

  configureFlags = [
    "--sysconfdir=/etc/clamav"
    "--with-zlib=${zlib.dev}"
    "--disable-zlib-vcheck" # it fails to recognize that 1.2.10 >= 1.2.2
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
