{ stdenv, fetchFromGitHub, meson, ninja, pkgconfig
, glib, systemd, udev, libevdev, gitMinimal, check, valgrind, swig, python3
, json-glib, libunistring }:

stdenv.mkDerivation rec {
  pname = "libratbag";
  version = "0.13";

  src = fetchFromGitHub {
    owner  = "libratbag";
    repo   = "libratbag";
    rev    = "v${version}";
    sha256 = "18y8mfr63d91278m1kcid0wvrxa1sgjs8na9af1ks2n28ssvciwq";
  };

  nativeBuildInputs = [
    meson ninja pkgconfig gitMinimal swig check valgrind
  ];

  buildInputs = [
    glib systemd udev libevdev json-glib libunistring
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
