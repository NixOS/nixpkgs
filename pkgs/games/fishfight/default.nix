{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, alsa-lib
, libGL
, libX11
, libXi
, AudioToolbox
, Cocoa
, CoreAudio
, CoreFoundation
, IOKit
, OpenGL
}:

rustPlatform.buildRustPackage rec {
  pname = "fishfight";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "fishfight";
    repo = pname;
    rev = "v${version}";
    sha256 = "0mbg9zshyg9hlbsk5npslbnwjf8fh6gxszi5hxks380z080cjxs2";
  };

  cargoSha256 = "sha256-fZXqJ6a2erAQSgAZRwmkor94eMryjiq3gbY102pJb9Q=";

  buildInputs = lib.optionals stdenv.isLinux [
    alsa-lib
    libGL
    libX11
    libXi
  ] ++ lib.optionals stdenv.isDarwin [
    AudioToolbox
    Cocoa
    CoreAudio
    CoreFoundation
    IOKit
    OpenGL
  ];

  postPatch = ''
    substituteInPlace assets/levels/levels.toml --replace assets $out/share/assets
    substituteInPlace src/gui.rs --replace \"assets \"$out/share/assets
    substituteInPlace src/main.rs --replace \"assets \"$out/share/assets
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
    mainProgram = "fishgame";
  };
}
