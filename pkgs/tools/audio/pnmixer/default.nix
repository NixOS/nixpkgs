{ stdenv, fetchFromGitHub, cmake, pkgconfig, gettext, alsaLib, gtk3, glib, libnotify, libX11 }:

stdenv.mkDerivation rec {
  name = "pnmixer-${version}";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "nicklan";
    repo = "pnmixer";
    rev = "v${version}";
    sha256 = "0mmrq4m2rk0wmkfmqs3fk2rnw5g5lvd7ill2s3d7ggf9vba1pcn2";
  };

  nativeBuildInputs = [ cmake pkgconfig gettext ];

  buildInputs = [ alsaLib gtk3 glib libnotify libX11 ];

  meta = with stdenv.lib; {
    homepage = https://github.com/nicklan/pnmixer;
    description = "ALSA volume mixer for the system tray";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ campadrenalin romildo ];
  };
}
