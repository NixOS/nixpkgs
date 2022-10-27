{ stdenv
, lib
, fetchFromGitHub
, rustPlatform
, AppKit
, Cocoa
, Foundation
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "topgrade";
  version = "10.0.1";

  src = fetchFromGitHub {
    owner = "topgrade-rs";
    repo = "topgrade";
    rev = "v${version}";
    sha256 = "sha256-mrBcgzlAsikpxkCD8OGKyUPOYkgp7giPCaZPbzCcXg4=";
  };

  cargoSha256 = "sha256-ImEnGhBjjHtAeoFqyeNKm39Bqs/icPstybFUlouBbFM=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [ AppKit Cocoa Foundation ];

  NIX_CFLAGS_COMPILE = lib.optionals stdenv.isDarwin [ "-framework" "AppKit" ];

  postInstall = ''
    installManPage topgrade.8
  '';

  meta = with lib; {
    description = "Upgrade all the things";
    homepage = "https://github.com/topgrade-rs/topgrade";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ SuperSandro2000 xyenon ];
  };
}
