{ lib, stdenv, fetchFromGitHub, rustPlatform, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "nixdoc";
  version = "3.0.3";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nixdoc";
    rev = "v${version}";
    sha256 = "sha256-K4esnYD/fc4i2To9lccoZ5GUgRI75vjzNLMrFSdZzik=";
  };

  cargoHash = "sha256-Ag6n0inWpBJ9U49fJ1JmwpnZdokJ0WS5fnlVBMN7VXM=";

  buildInputs = lib.optionals stdenv.isDarwin [ darwin.Security ];

  meta = with lib; {
    description = "Generate documentation for Nix functions";
    mainProgram = "nixdoc";
    homepage    = "https://github.com/nix-community/nixdoc";
    license     = [ licenses.gpl3 ];
    maintainers = with maintainers; [
      infinisil
      hsjobeki
    ];
    platforms   = platforms.unix;
  };
}
