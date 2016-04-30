{ stdenv, fetchFromGitHub, alsaLib, pkgconfig, gtk3, glibc, autoconf, automake, libnotify, libX11, intltool }:

stdenv.mkDerivation rec {
  name = "pnmixer-${version}";
  version = "2016-04-23";

  src = fetchFromGitHub {
    owner = "nicklan";
    repo = "pnmixer";
    rev = "cb20096716dbb5440b6560d81108d9c8f7188c48";
    sha256 = "17gl5fb3hpdgxyys8h5k3nraw7qdyqv9k9kz8ykr5h7gg29nxy66";
  };

  nativeBuildInputs = [
    pkgconfig autoconf automake intltool
  ];

  buildInputs = [
    alsaLib gtk3 glibc libnotify libX11
  ];

  preConfigure = ''
    ./autogen.sh
  '';

  # work around a problem related to gtk3 updates
  NIX_CFLAGS_COMPILE = "-Wno-error=deprecated-declarations";

  meta = with stdenv.lib; {
    homepage = https://github.com/nicklan/pnmixer;
    description = "ALSA mixer for the system tray";
    license = licenses.gpl3;
    maintainers = with maintainers; [ campadrenalin ];
    platforms = platforms.linux;
  };
}
