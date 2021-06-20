{ lib, stdenv, fetchFromGitHub, fetchpatch, cmake, boost, SDL2, SDL2_image, SDL2_ttf, libpng
, glew, gettext, libsndfile, libvorbis, libogg, physfs, openal
, xmlstarlet, doxygen, python3, callPackage }:

let
  colobot-data = callPackage ./data.nix {};
in
stdenv.mkDerivation rec {
  pname = "colobot";
  # Maybe require an update to package colobot-data as well
  # in file data.nix next to this one
  version = "0.1.12-alpha";

  src = fetchFromGitHub {
    owner = "colobot";
    repo = "colobot";
    rev = "colobot-gold-${version}";
    sha256 = "0viq5s4zqs33an7rdmc3anf74ml7mwwcwf60alhvp9hj5jr547s2";
  };

  patches = [
    # Fix issue with newer compilers, like used in nixpkgs
    # https://github.com/colobot/colobot/pull/1291
    (fetchpatch {
      url = "https://github.com/colobot/colobot/commit/fc2bd68876ac6302dbc8e91e8ffa33592db14b21.patch";
      sha256 = "sha256-PKe8jeyHpTT86tprSafQhNqTYBrSonz+r2fL1lVJdfo=";
    })
  ];

  nativeBuildInputs = [ cmake xmlstarlet doxygen python3 ];
  buildInputs = [ boost SDL2 SDL2_image SDL2_ttf libpng glew gettext libsndfile libvorbis libogg physfs openal ];

  enableParallelBuilding = false;

  # The binary ends in games directoy
  postInstall = ''
    mv $out/games $out/bin
    for contents in ${colobot-data}/share/games/colobot/*; do
      ln -s $contents $out/share/games/colobot
    done
  '';

  meta = with lib; {
    homepage = "https://colobot.info/";
    description = "Colobot: Gold Edition is a real-time strategy game, where you can program your bots";
    license = licenses.gpl3;
    maintainers = with maintainers; [ freezeboy ];
    platforms = platforms.linux;
  };
}
