{ lib, stdenv, fetchFromGitHub, rustPlatform, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "nixdoc";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo  = "nixdoc";
    rev = "v${version}";
    sha256 = "sha256-8pp6xlmdb3kZ6unTiO4yRruyEZ//GIHZF1k8f4kQr9Q=";
  };

  cargoSha256 = "sha256-k8/+BBMjQCsrgCi33fTdiSukaAZlg6XU3NwXaJdGYVw=";

  buildInputs =  lib.optionals stdenv.isDarwin [ darwin.Security ];

  meta = with lib; {
    description = "Generate documentation for Nix functions";
    homepage    = "https://github.com/nix-community/nixdoc";
    license     = [ licenses.gpl3 ];
    maintainers = [ maintainers.asymmetric ];
    platforms   = platforms.unix;
  };
}
