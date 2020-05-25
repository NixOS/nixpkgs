{ stdenv, fetchgit, autoreconfHook, pkgconfig, pythonPackages
, libevdev
}:

stdenv.mkDerivation rec {
  pname = "evemu";
  version = "2.6.0";

  # We could have downloaded a release tarball from cgit, but it changes hash
  # each time it is downloaded :/
  src = fetchgit {
    url = "git://git.freedesktop.org/git/evemu";
    rev = "refs/tags/v${version}";
    sha256 = "1m38fxwy2s82vb2qm9aqxinws12akmqqq7q66is931lc3awqkbah";
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook ];

  buildInputs = [ pythonPackages.python pythonPackages.evdev libevdev ];

  meta = with stdenv.lib; {
    description = "Records and replays device descriptions and events to emulate input devices through the kernel's input system";
    homepage = "https://www.freedesktop.org/wiki/Evemu/";
    repositories.git = "git://git.freedesktop.org/git/evemu";
    license = licenses.gpl2;
    maintainers = [ maintainers.amorsillo ];
    platforms = platforms.linux;
  };
}
