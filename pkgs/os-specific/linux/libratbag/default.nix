{ lib, stdenv, fetchFromGitHub, meson, ninja, pkg-config
, glib, systemd, udev, libevdev, gitMinimal, check, valgrind, swig, python3
, json-glib, libunistring }:

stdenv.mkDerivation rec {
  pname = "libratbag";
  version = "0.17";

  src = fetchFromGitHub {
    owner  = "libratbag";
    repo   = "libratbag";
    rev    = "v${version}";
    sha256 = "sha256-TQ8DVj4yqq3IA0oGnLDz+QNTyNRmGqspEjkPeBmXNew=";
  };

  nativeBuildInputs = [
    meson ninja pkg-config gitMinimal swig check valgrind
  ];

  buildInputs = [
    glib systemd udev libevdev json-glib libunistring
    (python3.withPackages (ps: with ps; [ evdev pygobject3 ]))
  ];

  mesonFlags = [
    "-Dsystemd-unit-dir=./lib/systemd/system/"
  ];

  meta = with lib; {
    description = "Configuration library for gaming mice";
    homepage    = "https://github.com/libratbag/libratbag";
    license     = licenses.mit;
    maintainers = with maintainers; [ mvnetbiz ];
    platforms   = platforms.linux;
  };
}
