{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchzip,
  cmake,
  SDL2,
  SDL2_mixer,
  Cocoa,
  unrar-wrapper,
  makeWrapper,
}:

let
  assets =
    (fetchzip {
      url = "https://archive.org/download/SpaceCadet_Plus95/Space_Cadet.rar";
      sha256 = "sha256-fC+zsR8BY6vXpUkVd6i1jF0IZZxVKVvNi6VWCKT+pA4=";
      stripRoot = false;
    }).overrideAttrs
      (old: {
        nativeBuildInputs = old.nativeBuildInputs ++ [ unrar-wrapper ];
      });
in
stdenv.mkDerivation rec {
  pname = "SpaceCadetPinball";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "k4zmu2a";
    repo = pname;
    rev = "Release_${version}";
    hash = "sha256-W2P7Txv3RtmKhQ5c0+b4ghf+OMsN+ydUZt+6tB+LClM=";
  };

  nativeBuildInputs = [
    cmake
    makeWrapper
  ];
  buildInputs = [
    SDL2
    SDL2_mixer
  ] ++ lib.optional stdenv.isDarwin Cocoa;

  # Darwin needs a custom installphase since it is excluded from the cmake install
  # https://github.com/k4zmu2a/SpaceCadetPinball/blob/0f88e43ba261bc21fa5c3ef9d44969a2a079d0de/CMakeLists.txt#L221
  installPhase = lib.optionalString stdenv.isDarwin ''
    runHook preInstall
    mkdir -p $out/bin
    install ../bin/SpaceCadetPinball $out/bin
    runHook postInstall
  '';

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
    license = with licenses; [
      unfree
      mit
    ];
    maintainers = [ maintainers.hqurve ];
    platforms = platforms.all;
    mainProgram = "SpaceCadetPinball";
  };
}
