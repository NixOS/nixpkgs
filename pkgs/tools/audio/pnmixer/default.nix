{ stdenv, fetchFromGitHub, cmake, pkgconfig, gettext, alsaLib, gtk3, glib, libnotify, libX11, pcre }:

stdenv.mkDerivation rec {
  pname = "pnmixer";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "nicklan";
    repo = "pnmixer";
    rev = "v${version}";
    sha256 = "0416pa933ddf4b7ph9zxhk5jppkk7ppcq1aqph6xsrfnka4yb148";
  };

  nativeBuildInputs = [ cmake pkgconfig gettext ];

  buildInputs = [ alsaLib gtk3 glib libnotify libX11 pcre ];

  meta = with stdenv.lib; {
    homepage = https://github.com/nicklan/pnmixer;
    description = "ALSA volume mixer for the system tray";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ campadrenalin romildo ];
  };
}
