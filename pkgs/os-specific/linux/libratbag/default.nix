{ stdenv, fetchFromGitHub, meson, ninja, pkgconfig
, glib, systemd, udev, libevdev, gitMinimal, check, valgrind, swig, python3 }:

stdenv.mkDerivation rec {
  name = "libratbag-${version}";
  version = "0.9.903";

  src = fetchFromGitHub {
    owner  = "libratbag";
    repo   = "libratbag";
    rev    = "v${version}";
    sha256 = "0cr5skrb7a5mgj7dkm647ib8336hb88bf11blaf6xldafi8b0jlj";
  };


  # todo: python should be in buildInputs, but right now meson propagates
  # its own python. see: https://github.com/NixOS/nixpkgs/pull/46020
  nativeBuildInputs = [
    (python3.withPackages (ps: with ps; [ evdev pygobject3 ]))
    meson ninja pkgconfig gitMinimal swig check valgrind
  ];

  buildInputs = [ glib systemd udev libevdev ];

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
