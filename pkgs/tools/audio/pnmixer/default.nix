{ stdenv, fetchFromGitHub, cmake, pkgconfig, gettext, alsaLib, gtk3, glib, libnotify, libX11 }:

stdenv.mkDerivation rec {
  name = "pnmixer-${version}";
  version = "0.7.1-rc1";

  src = fetchFromGitHub {
    owner = "nicklan";
    repo = "pnmixer";
    rev = "v${version}";
    sha256 = "0ns7s1jsc7fc3fvs9m3xwbv1fk1410cqc5w1cmia1mlzy94r3r6p";
  };

  nativeBuildInputs = [ cmake pkgconfig gettext ];

  buildInputs = [ alsaLib gtk3 glib libnotify libX11 ];

  meta = with stdenv.lib; {
    homepage = https://github.com/nicklan/pnmixer;
    description = "ALSA mixer for the system tray";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ campadrenalin romildo ];
  };
}
