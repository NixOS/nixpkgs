{ stdenv
, lib
, fetchurl
, pkg-config
, libX11
, libXft
, libXtst
, libXi
, libXinerama
, layout ? "mobile-intl"
}:

assert lib.assertOneOf "layout" layout [ "mobile-intl" "mobile-plain" "de" "en" "ru" "sh" "arrows" ];

stdenv.mkDerivation rec {
  pname = "svkbd";
  version = "0.3";

  src = fetchurl {
    url = "https://dl.suckless.org/tools/svkbd-${version}.tar.gz";
    sha256 = "108khx665d7dlzs04iy4g1nw3fyqpy6kd0afrwiapaibgv4xhfsk";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libX11 libXft libXtst libXi libXinerama ];

  makeFlags = [ "LAYOUT=${layout}" ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Simple Virtual Keyboard";
    homepage = "https://tools.suckless.org/x/svkbd/";
    license = licenses.mit;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.linux;
  };
}
