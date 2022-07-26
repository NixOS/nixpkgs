{ stdenv, lib, fetchurl
, autoreconfHook, libtool, pkg-config
, gtk2, glib, cups, gettext, openssl
}:

stdenv.mkDerivation rec {
  pname = "gtklp";
  version = "1.3.4";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.src.tar.gz";
    sha256 = "1arvnnvar22ipgnzqqq8xh0kkwyf71q2sfsf0crajpsr8a8601xy";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  buildInputs = [
    cups
    gettext
    glib
    gtk2
    libtool
    openssl
  ];

  patches = [
    ./patches/mdv-fix-str-fmt.patch
    ./patches/autoconf.patch
  ];

  # Workaround build failure on -fno-common toolchains:
  #   ld: libgtklp.a(libgtklp.o):libgtklp/libgtklp.h:83: multiple definition of `progressBar';
  #     file.o:libgtklp/libgtklp.h:83: first defined here
  NIX_CFLAGS_COMPILE = "-fcommon";

  preConfigure = ''
    substituteInPlace include/defaults.h --replace "netscape" "firefox"
    substituteInPlace include/defaults.h --replace "http://localhost:631/sum.html#STANDARD_OPTIONS" \
                                                   "http://localhost:631/help/"
  '';

  preInstall = ''
    install -D -m0644 -t $out/share/doc AUTHORS BUGS ChangeLog README USAGE
  '';

  meta = with lib; {
    description = "A graphical frontend for CUPS";
    homepage = "https://gtklp.sirtobi.com";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ caadar ];
    platforms = platforms.unix;
  };

}
