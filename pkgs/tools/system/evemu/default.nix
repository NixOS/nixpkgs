{ stdenv, fetchgit, automake, autoconf, libtool, pkgconfig, pythonPackages, libevdev, linuxHeaders }:
stdenv.mkDerivation rec {
  name = "evemu";

  src = fetchgit {
    url = git://git.freedesktop.org/git/evemu;
    rev = "81ef21d31ec0f5a4208e77d85989d6588be3c4c1";
    sha256 = "1509b524a2483054a45698c485968094dd8c0f857bba7333449e9d05acbfbd2c";
  };

  buildInputs = [ automake autoconf libtool pkgconfig pythonPackages.python pythonPackages.evdev libevdev ];

  preConfigure = ''
    ./autogen.sh --prefix=$out
  '';

  postPatch = ''
    substituteInPlace src/make-event-names.py --replace "/usr/include/linux/input.h" "${linuxHeaders}/include/linux/input.h"
  '';

  meta = {
    description = "evemu records and replays device descriptions and events to emulate input devices through the kernel's input system";
    homepage = http://www.freedesktop.org/wiki/Evemu/;
    repositories.git = git://git.freedesktop.org/git/evemu;
    license = stdenv.lib.licenses.gpl2;
    maintainer = with stdenv.lib.maintainers; [ amorsillo ];
  };
}
