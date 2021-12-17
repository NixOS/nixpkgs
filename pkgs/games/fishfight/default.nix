{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, SDL2
, alsa-lib
, libGL
, libX11
, libXi
, AudioToolbox
, Cocoa
, CoreAudio
, OpenGL
}:

rustPlatform.buildRustPackage rec {
  pname = "fishfight";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "fishfight";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-kLdk7zTICZ8iawNttTsWUVKGvh2zykXVsMqUyYoGrBs=";
  };

  # use system sdl2 instead of bundled sdl2
  cargoPatches = [ ./use-system-sdl2.patch ];

  cargoSha256 = "sha256-KQiqUzdsVMIjDmmreihekrrFoXeyNzd6ZbqApwH8B4Q=";

  buildInputs =  [
    SDL2
  ] ++ lib.optionals stdenv.isLinux [
    alsa-lib
    libGL
    libX11
    libXi
  ] ++ lib.optionals stdenv.isDarwin [
    AudioToolbox
    Cocoa
    CoreAudio
    OpenGL
  ];

  postPatch = ''
    substituteInPlace src/main.rs --replace ./assets $out/share/assets
  '';

  postInstall = ''
    mkdir $out/share
    cp -r assets $out/share
  '';

  meta = with lib; {
    description = "A tactical 2D shooter played by up to 4 players online or on a shared screen";
    homepage = "https://fishfight.org/";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
