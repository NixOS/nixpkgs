{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  cmake,
  makeWrapper,
  pkg-config,
  fontconfig,
  wayland,
  libX11,
  libXcursor,
  libXrandr,
  libXi,
  libGL,
  libxcb,
  AppKit,
}:

let
  libPath = lib.makeLibraryPath [
    # broken on darwin: wayland
    libX11
    libXcursor
    libXrandr
    libXi
    libxcb
    libGL
  ];
in

rustPlatform.buildRustPackage rec {
  pname = "tickets-rs";
  version = "unstable-2023-01-09";

  src = fetchFromGitHub {
    owner = "TheBiochemic";
    repo = "tickets-rs";
    rev = "be4e558c094103d266261b5a0226e8fcbebe473b";
    sha256 = "sha256-cFV5CTVWGl7SQlHOdLECsOKixn4QFwmqizOhbmspR2I=";
  };

  cargoSha256 = "sha256-lS/va8mPC7iCzxxn2EjUetVS3wLS5i9ORjhq6q83nms=";

  nativeBuildInputs = [
    cmake
    pkg-config
    makeWrapper
  ];
  buildInputs = lib.optionals stdenv.isLinux [
    fontconfig
  ] ++ lib.optionals stdenv.isDarwin [
    AppKit
  ];

  LD_LIBRARY_PATH = libPath;

  postInstall = ''
    wrapProgram "$out/bin/tickets-rs" --prefix LD_LIBRARY_PATH : "${libPath}"
  '';

  meta = with lib; {
    description = "A Ticket Management Tool";
    homepage = "https://github.com/TheBiochemic/tickets-rs";
    license = licenses.gpl3;
    maintainers = with maintainers; [ _0x4A6F ];
  };
}
