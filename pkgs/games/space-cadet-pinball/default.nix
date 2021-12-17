{ lib, stdenv, fetchFromGitHub, fetchzip
, cmake, SDL2, SDL2_mixer
, unrar-wrapper, makeWrapper
}:

let
  assets = (fetchzip {
    url = "https://archive.org/download/SpaceCadet_Plus95/Space_Cadet.rar";
    sha256 = "sha256-fC+zsR8BY6vXpUkVd6i1jF0IZZxVKVvNi6VWCKT+pA4=";
    stripRoot = false;
  }).overrideAttrs (old: {
    nativeBuildInputs = old.nativeBuildInputs ++ [ unrar-wrapper ];
  });
in
stdenv.mkDerivation rec {
  pname = "SpaceCadetPinball";
  version = "unstable-2021-12-02";

  src = fetchFromGitHub {
    owner = "k4zmu2a";
    repo = pname;
    rev = "de13d4e326b2dfa8e6dfb59815c0a8b9657f942d";
    sha256 = "sha256-/nk4kNsmL1z2rKgV1dh9gcVjp8xJwovhE6/u2aNl/fA=";
  };

  buildInputs = [
    SDL2
    SDL2_mixer
    cmake
    makeWrapper
  ];

  postInstall = ''
    mkdir -p $out/lib/SpaceCadetPinball
    install ${assets}/*.{DAT,DOC,MID,BMP,INF} ${assets}/Sounds/*.WAV $out/lib/SpaceCadetPinball

    # Assets are loaded from the directory of the program is stored in
    # https://github.com/k4zmu2a/SpaceCadetPinball/blob/de13d4e326b2dfa8e6dfb59815c0a8b9657f942d/SpaceCadetPinball/winmain.cpp#L119
    mv $out/bin/SpaceCadetPinball $out/lib/SpaceCadetPinball
    makeWrapper $out/lib/SpaceCadetPinball/SpaceCadetPinball $out/bin/SpaceCadetPinball
  '';

  meta = with lib; {
    description = "Reverse engineering of 3D Pinball for Windows – Space Cadet, a game bundled with Windows";
    homepage = "https://github.com/k4zmu2a/SpaceCadetPinball";
    # The assets are unfree while the code is labeled as MIT
    license = with licenses; [ unfree mit ];
    maintainers = [ maintainers.hqurve ];
    platforms = platforms.all;
  };
}
