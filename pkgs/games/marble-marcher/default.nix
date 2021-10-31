{ lib, stdenv, fetchFromGitHub, makeWrapper, cmake, eigen, sfml, libglvnd }:
let
  pname = "marble-marcher";

  # The game doesn’t have any versions in GitHub.
  # Just taking a commit from the top of the “master” branch.
  version = "unstable-2019-04-22";

  src = fetchFromGitHub {
    owner = "HackerPoet";
    repo = "MarbleMarcher";
    rev = "478afb8ea9c894d6d8b961583aa557e2f63d6198";
    sha256 = "1kpn9wnf14wm7867dp3lhb10065h4vzy101gab18zkphlwl1dbwq";
  };
  assets = stdenv.mkDerivation {
    pname = "${pname}-assets-pack";
    inherit version src;
    installPhase = ''
      mkdir -p -- "$out/assets" || exit
      cp -- "$src/assets/"* "$out/assets" || exit
    '';
    meta = with lib; {
      homepage = "https://codeparade.itch.io/marblemarcher";
      description = "Assets for MarbleMarcher videogame";
      maintainers = with maintainers; [ unclechu ];
      platforms = platforms.linux;

      # This assets pack contains:
      # - A couple of fonts (CC-BY-SA 3.0 and SIL OFL 1.1, with license text files)
      # - Vertex and fragment shaders under GNU/GPLv2 and later
      # - Images (png, ico) with not clear license
      # - Audio files (wav, ogg) with not clear license
      license = licenses.unfree;
    };
  };
in stdenv.mkDerivation {
  inherit pname version src;
  nativeBuildInputs = [ cmake makeWrapper ];
  buildInputs = [ eigen sfml libglvnd ];
  buildPhase = ''
    mkdir build || exit
    (cd build && cmake "$src") || exit
    cmake --build build || exit
  '';
  installPhase = ''
    mkdir -p -- "$out"/bin || exit
    cp -- build/MarbleMarcher "$out"/bin || exit
    wrapProgram "$out/bin/MarbleMarcher" \
      --run ${lib.escapeShellArg "cd -- ${lib.escapeShellArg assets}"} || exit
  '';
  meta = with lib; {
    homepage = "https://codeparade.itch.io/marblemarcher";
    description = "A videogame based on fractal physics engine";
    longDescription = ''
      Marble Marcher is a video game demo that uses a fractal physics engine and
      fully procedural rendering to produce beautiful and unique gameplay unlike
      anything you've seen before.

      The goal of the game is to reach the flag as quickly as possible. But be
      careful not to fall off the level or get crushed by the fractal! There are
      24 levels to unlock.
    '';
    maintainers = with maintainers; [ unclechu ];
    license = licenses.gpl2Only;
    platforms = platforms.linux;
  };
}
