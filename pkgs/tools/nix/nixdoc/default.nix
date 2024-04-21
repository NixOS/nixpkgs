{ lib, stdenv, fetchFromGitHub, rustPlatform, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "nixdoc";
  version = "3.0.4";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nixdoc";
    rev = "v${version}";
    sha256 = "sha256-HnU1zDXpJxtz+Cv9VwrvwLc86AMoQWu/ypSsuHbiHlA=";
  };

  cargoHash = "sha256-HF/oqw4naxskq9REMFq/bmFVUgkVcuYr5A6yIkFd2qQ=";

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
