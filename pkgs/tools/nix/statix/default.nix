{ lib, rustPlatform, fetchFromGitHub, withJson ? true }:

rustPlatform.buildRustPackage rec {
  pname = "statix";
  # also update version of the vim plugin in pkgs/misc/vim-plugins/overrides.nix
  # the version can be found in flake.nix of the source code
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "nerdypepper";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-8xWtwa9ZtkcpWvLG2QS3jPlz2c+E5MjYWhZ/g5bjhkc=";
  };

  cargoSha256 = "sha256-f8f5wJyK+q6zTfNiCRN89ptlSWfSnrzLyefTIpw5mts=";

  cargoBuildFlags = lib.optionals withJson [ "--features" "json" ];

  cargoCheckFlags = cargoBuildFlags;

  meta = with lib; {
    description = "Lints and suggestions for the nix programming language";
    homepage = "https://github.com/nerdypepper/statix";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda nerdypepper ];
  };
}
