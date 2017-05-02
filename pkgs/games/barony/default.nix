{ stdenv, lib, fetchFromGitHub
, pkgconfig, cmake, mesa, SDL2, SDL2_net, SDL2_image, SDL2_ttf
, libpng, openal, libvorbis }:

let
  version = "2.0.5";
in
stdenv.mkDerivation {
  name = "barony-${version}";

  src = fetchFromGitHub {
    owner = "TurningWheel";
    repo = "Barony";
    rev = "2081c1bdf37099cea859cbbadb64c8a6846bae7a";
    sha256 = "1279pp2sk217rfrqjikbn8h8g9pshll8nzqk40wzai323cs9b6b2";
  };

  nativeBuildInputs = [ pkgconfig cmake ];

  buildInputs = [ SDL2 mesa SDL2_net SDL2_image SDL2_ttf libpng openal libvorbis ];

  cmakeFlags = [ "-DFMOD_ENABLED=OFF" "-DOPENAL_ENABLED=ON" ];

  buildPhase = "make barony";

  installPhase = ''
    mkdir -p $out/bin
    cp barony $out/bin
  '';

  patches = [
    ./data-dir.patch
    ./no-redirect.patch
    ./revert-minotaur.patch
    ./format-security.patch
  ];

  meta = with lib; {
    description = "a 3D, first-person roguelike";
    homepage = http://www.baronygame.com/;
    license = licenses.gpl3;
    platforms = platforms.linux; # May build on more, but not tested
    maintainers = with maintainers; [ lheckemann ];
  };
}
