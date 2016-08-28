{ stdenv, fetchgit, autoreconfHook, pkgconfig, pythonPackages
, libevdev, linuxHeaders
}:

stdenv.mkDerivation rec {
  name = "evemu-${version}";
  version = "2.4.0";

  # We could have downloaded a release tarball from cgit, but it changes hash
  # each time it is downloaded :/
  src = fetchgit {
    url = git://git.freedesktop.org/git/evemu;
    rev = "refs/tags/v${version}";
    sha256 = "07iha13xrpf4z59rzl9cm2h1zkc5xhyipbd3ajd3c1d4hhpn9w9s";
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook ];

  buildInputs = [ pythonPackages.python pythonPackages.evdev libevdev ];

  meta = with stdenv.lib; {
    description = "Records and replays device descriptions and events to emulate input devices through the kernel's input system";
    homepage = http://www.freedesktop.org/wiki/Evemu/;
    repositories.git = git://git.freedesktop.org/git/evemu;
    license = licenses.gpl2;
    maintainers = [ maintainers.amorsillo ];
    platforms = platforms.linux;
  };
}
