{ lib
, stdenv
, fetchFromGitHub
, SDL2
, SDL2_mixer
, cmake
, libpng
, darwin
, libicns
, imagemagick
}:
stdenv.mkDerivation rec {
  pname = "julius";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "bvschaik";
    repo = "julius";
    rev = "v${version}";
    hash = "sha256-I5GTaVWzz0ryGLDSS3rzxp+XFVXZa9hZmgwon/6r83A=";
  };

  patches = [
    # This fixes the darwin bundle generation, sets min. deployment version
    # and patches SDL2_mixer include
    ./darwin-fixes.patch
  ];

  nativeBuildInputs = [
    cmake
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.sigtool
    libicns
    imagemagick
  ];

  buildInputs = [
    SDL2
    SDL2_mixer
    libpng
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Cocoa
  ];

  installPhase = lib.optionalString stdenv.isDarwin ''
    runHook preInstall
    mkdir -p $out/Applications
    cp -r julius.app $out/Applications/
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/bvschaik/julius";
    description = "Open source re-implementation of Caesar III";
    mainProgram = "julius";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ Thra11 matteopacini ];
    platforms = platforms.all;
  };
}
