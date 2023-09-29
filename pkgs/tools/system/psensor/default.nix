{ stdenv, lib, fetchurl, pkg-config, lm_sensors, libgtop, libatasmart, gtk3
, libnotify, udisks2, libXNVCtrl, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "psensor";

  version = "1.2.1";

  src = fetchurl {
    url = "https://wpitchoune.net/psensor/files/psensor-${version}.tar.gz";
    sha256 = "1ark901va79gfq5p8h8dqypjgm3f8crmj37520q3slwz2rfphkq8";
  };

  nativeBuildInputs = [ pkg-config wrapGAppsHook ];

  buildInputs = [
    lm_sensors libgtop libatasmart gtk3 libnotify udisks2
  ];

  preConfigure = ''
    NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${libXNVCtrl}/include -Wno-error"
    NIX_LDFLAGS="$NIX_LDFLAGS -L${libXNVCtrl}/lib"
  '';

  meta = with lib; {
    description = "Graphical hardware monitoring application for Linux";
    homepage = "https://wpitchoune.net/psensor/";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}
