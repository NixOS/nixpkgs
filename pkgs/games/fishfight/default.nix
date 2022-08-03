{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, pkg-config
, alsa-lib
, libGL
, libX11
, libXi
, udev
, Cocoa
, OpenGL
}:

rustPlatform.buildRustPackage rec {
  pname = "fishfight";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "fishfight";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-q1Hh4P/huoFuW/+Mb9yKUMKaky1RshGpjrObBHRCk+8=";
  };

  cargoSha256 = "sha256-PEGK95eXIHv2sxSwUU4345KtxDyRJn/+aEiJIDmkq6Y=";

  nativeBuildInputs = lib.optionals stdenv.isLinux [
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.isLinux [
    alsa-lib
    libGL
    libX11
    libXi
    udev
  ] ++ lib.optionals stdenv.isDarwin [
    Cocoa
    OpenGL
  ];

  postPatch = ''
    substituteInPlace src/main.rs \
      --replace ./assets $out/share/assets \
      --replace ./mods $out/share/mods
  '';

  postInstall = ''
    mkdir $out/share
    cp -r assets mods $out/share
  '';

  meta = with lib; {
    description = "A tactical 2D shooter played by up to 4 players online or on a shared screen";
    homepage = "https://fishfight.org/";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
