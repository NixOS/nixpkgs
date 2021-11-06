{ lib, rustPlatform, fetchFromGitHub, withJson ? true }:

rustPlatform.buildRustPackage rec {
  pname = "statix";
  # also update version of the vim plugin in pkgs/misc/vim-plugins/overrides.nix
  # the version can be found in flake.nix of the source code
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "nerdypepper";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-wqkhtAOO6pKLjUUnDbVFwzm6mbXhP/4iJU7ZKtDKrE8=";
  };

  cargoSha256 = "sha256-e20POz9ZvuT0S+YG+9x7hcudhXQpOR4rVSFJbz76OI0=";

  cargoBuildFlags = lib.optionals withJson [ "--features" "json" ];

  cargoCheckFlags = cargoBuildFlags;

  meta = with lib; {
    description = "Lints and suggestions for the nix programming language";
    homepage = "https://github.com/nerdypepper/statix";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda nerdypepper ];
  };
}
