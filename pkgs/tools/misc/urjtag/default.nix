{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  gettext,
  libftdi1,
  libtool,
  libusb-compat-0_1,
  pkg-config,
  readline,
  which,
  bsdlSupport ? true,
  jedecSupport ? true,
  staplSupport ? true,
  svfSupport ? true,
}:

stdenv.mkDerivation rec {
  pname = "urjtag";
  version = "2021.03";

  src = fetchurl {
    url = "mirror://sourceforge/project/${pname}/${pname}/${version}/${pname}-${version}.tar.xz";
    hash = "sha256-sKLqokVROvCW3E13AQmDIzXGlMbBKqXpL++uhoVBbxw=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    which
    gettext
  ];
  buildInputs = [
    libftdi1
    libtool
    libusb-compat-0_1
    readline
  ];

  configureFlags = [
    (lib.enableFeature bsdlSupport "bsdl")
    (lib.enableFeature jedecSupport "jedec-exp")
    (lib.enableFeature staplSupport "stapl")
    (lib.enableFeature svfSupport "svf")
  ];

  meta = with lib; {
    homepage = "http://urjtag.org/";
    description = "Universal JTAG library, server and tools";
    license = with licenses; [
      gpl2Plus
      lgpl21Plus
    ];
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.linux;
  };
}
