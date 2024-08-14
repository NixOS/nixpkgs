{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  SDL2,
  SDL2_mixer,
  libpng,
  darwin,
  libicns,
  imagemagick,
}:

stdenv.mkDerivation rec {
  pname = "augustus";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "Keriew";
    repo = "augustus";
    rev = "v${version}";
    sha256 = "sha256-UWJmxirRJJqvL4ZSjBvFepeKVvL77+WMp4YdZuFNEkg=";
  };

  patches = [ ./darwin-fixes.patch ];

  nativeBuildInputs =
    [ cmake ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.sigtool
      libicns
      imagemagick
    ];

  buildInputs = [
    SDL2
    SDL2_mixer
    libpng
  ] ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Cocoa ];

  installPhase = lib.optionalString stdenv.isDarwin ''
    runHook preInstall
    mkdir -p $out/Applications
    cp -r augustus.app $out/Applications/
    runHook postInstall
  '';

  meta = with lib; {
    description = "Open source re-implementation of Caesar III. Fork of Julius incorporating gameplay changes";
    mainProgram = "augustus";
    homepage = "https://github.com/Keriew/augustus";
    license = licenses.agpl3Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [
      Thra11
      matteopacini
    ];
  };
}
