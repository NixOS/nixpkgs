{ lib, stdenv, fetchFromGitHub, rustPlatform, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "nixdoc";
  version = "3.0.5";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nixdoc";
    rev = "v${version}";
    sha256 = "sha256-6aPfpkcUoAYaGYqBPFJJQvQ9dMGne9TWJ2HAx95JujY=";
  };

  cargoHash = "sha256-5bWP8dhApnQyK/gQNkPrLeqFvRVbSlVNRG6pRDb/fdk=";

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
