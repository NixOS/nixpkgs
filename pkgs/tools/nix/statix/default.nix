{ lib, rustPlatform, fetchFromGitHub, withJson ? true }:

rustPlatform.buildRustPackage rec {
  pname = "statix";
  # also update version of the vim plugin in pkgs/misc/vim-plugins/overrides.nix
  # the version can be found in flake.nix of the source code
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "nerdypepper";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-vJvHmg6X/B6wQYjeX1FZC4MDGo0HkKbTmQH+l4tZAwg=";
  };

  cargoSha256 = "sha256-OfLpnVe1QIjpjpD4ticG/7AxPGFMMjBWN3DdLZq6pA8=";

  cargoBuildFlags = lib.optionals withJson [ "--features" "json" ];

  cargoCheckFlags = cargoBuildFlags;

  meta = with lib; {
    description = "Lints and suggestions for the nix programming language";
    homepage = "https://github.com/nerdypepper/statix";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda nerdypepper ];
  };
}
