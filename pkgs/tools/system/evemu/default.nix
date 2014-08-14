{ stdenv, fetchgit, automake, autoconf, libtool, pkgconfig, pythonPackages
, libevdev, linuxHeaders
}:

stdenv.mkDerivation rec {
  name = "evemu-${version}";
  version = "2.0.0";

  # We could have downloaded a release tarball from cgit, but it changes hash
  # each time it is downloaded :/
  src = fetchgit {
    url = git://git.freedesktop.org/git/evemu;
    rev = "refs/tags/v${version}";
    sha256 = "1509b524a2483054a45698c485968094dd8c0f857bba7333449e9d05acbfbd2c";
  };

  buildInputs = [
    automake autoconf libtool pkgconfig pythonPackages.python
    pythonPackages.evdev libevdev
  ];

  preConfigure = ''
    ./autogen.sh --prefix=$out
  '';

  postPatch = ''
    substituteInPlace src/make-event-names.py --replace "/usr/include/linux/input.h" "${linuxHeaders}/include/linux/input.h"
  '';

  meta = with stdenv.lib; {
    description = "Records and replays device descriptions and events to emulate input devices through the kernel's input system";
    homepage = http://www.freedesktop.org/wiki/Evemu/;
    repositories.git = git://git.freedesktop.org/git/evemu;
    license = licenses.gpl2;
    maintainers = [ maintainers.amorsillo ];
  };
}
