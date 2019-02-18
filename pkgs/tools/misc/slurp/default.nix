{ stdenv, fetchFromGitHub, cairo, meson, ninja, wayland, pkgconfig, wayland-protocols }:

stdenv.mkDerivation rec {
  name = "slurp-${version}";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "emersion";
    repo = "slurp";
    rev = "v${version}";
    sha256 = "072lkwhpvr753wfqzmd994bnhbrgfavxcgqcyml7abab28sdhs1y";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
  ];

  buildInputs = [
    cairo
    wayland
    wayland-protocols
  ];

  meta = with stdenv.lib; {
    description = "Select a region in a Wayland compositor";
    homepage = https://github.com/emersion/slurp;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ buffet ];
  };
}
