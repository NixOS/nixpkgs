{ stdenv, fetchFromGitHub, cmake, meson, ninja, pkgconfig
, glib, systemd, udev, libevdev, check, json-glib, libunistring, valgrind, swig, python3 }:

stdenv.mkDerivation rec {
  pname = "libratbag";
  version = "0.10";

  src = fetchFromGitHub {
    owner  = "libratbag";
    repo   = "libratbag";
    rev    = "v${version}";
    sha256 = "10hahpv2n48b5z35d2draka7cz1a9vw53rvwfmpp5dibwnmi81jb";
  };

  nativeBuildInputs = [
    cmake meson ninja pkgconfig swig check valgrind
  ];

  buildInputs = [
    glib json-glib libunistring systemd udev libevdev
    (python3.withPackages (ps: with ps; [ evdev pygobject3 ]))
  ];

  mesonFlags = [
    "-Dsystemd-unit-dir=./lib/systemd/system/"
  ];

  dontUseCmakeConfigure = true;

  meta = with stdenv.lib; {
    description = "Configuration library for gaming mice";
    homepage    = "https://github.com/libratbag/libratbag";
    license     = licenses.mit;
    maintainers = with maintainers; [ mvnetbiz ];
    platforms   = platforms.linux;
  };
}
