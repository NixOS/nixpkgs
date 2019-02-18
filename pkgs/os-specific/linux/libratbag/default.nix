{ stdenv, fetchFromGitHub, meson, ninja, pkgconfig
, glib, systemd, udev, libevdev, gitMinimal, check, valgrind, swig, python3 }:

stdenv.mkDerivation rec {
  name = "libratbag-${version}";
  version = "0.9.904";

  src = fetchFromGitHub {
    owner  = "libratbag";
    repo   = "libratbag";
    rev    = "v${version}";
    sha256 = "0d2gw4bviy6zf1q9a18chlsbqylhppbby336fznh6nkpdl3jckfd";
  };

  nativeBuildInputs = [
    meson ninja pkgconfig gitMinimal swig check valgrind
  ];

  buildInputs = [
    glib systemd udev libevdev
    (python3.withPackages (ps: with ps; [ evdev pygobject3 ]))
  ];

  mesonFlags = [
    "-Dsystemd-unit-dir=./lib/systemd/system/"
  ];

  meta = with stdenv.lib; {
    description = "Configuration library for gaming mice";
    homepage    = https://github.com/libratbag/libratbag;
    license     = licenses.mit;
    maintainers = with maintainers; [ mvnetbiz ];
    platforms   = platforms.linux;
  };
}
