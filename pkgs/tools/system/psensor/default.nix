{ stdenv, lib, fetchurl, pkgconfig, lm_sensors, libgtop, libatasmart, gtk3
, libnotify, udisks2, libXNVCtrl, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  name = "psensor-${version}";

  version = "1.2.0";

  src = fetchurl {
    url = "http://wpitchoune.net/psensor/files/psensor-${version}.tar.gz";
    sha256 = "1smbidbby4rh14jnh9kn7y64qf486aqnmyxcgacjvkz27cqqnw4r";
  };

  nativeBuildInputs = [ pkgconfig wrapGAppsHook ];

  buildInputs = [
    lm_sensors libgtop libatasmart gtk3 libnotify udisks2
  ];

  preConfigure = ''
    NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${libXNVCtrl}/include"
    NIX_LDFLAGS="$NIX_LDFLAGS -L${libXNVCtrl}/lib"
  '';

  meta = with lib; {
    description = "Graphical hardware monitoring application for Linux";
    homepage = https://wpitchoune.net/psensor/;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cstrahan ];
  };
}
