{ stdenv, lib, fetchFromGitHub, pkgconfig, cmake, libinput, zlib }:

stdenv.mkDerivation rec {
  pname = "gebaar-libinput";
  version = "0.0.5";

  src = fetchFromGitHub {
    owner = "Coffee2CodeNL";
    repo = pname;
    rev = "v${version}";
    sha256 = "1kqcgwkia1p195xr082838dvj1gqif9d63i8a52jb0lc32zzizh6";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkgconfig cmake ];
  buildInputs = [ libinput zlib ];

  meta = with lib; {
    description = "Gebaar, A Super Simple WM Independent Touchpad Gesture Daemon for libinput";
    homepage = "https://github.com/Coffee2CodeNL/gebaar-libinput";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ colemickens lovesegfault ];
  };
}
