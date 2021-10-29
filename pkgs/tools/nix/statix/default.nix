{ lib, rustPlatform, fetchFromGitHub, withJson ? true }:

rustPlatform.buildRustPackage rec {
  pname = "statix";
  # also update version of the vim plugin in pkgs/misc/vim-plugins/overrides.nix
  # the version can be found in flake.nix of the source code
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "nerdypepper";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Jh3ErzK8vqEdDtZP7O/PAmHQznUTB18nCQwfckFxyLA=";
  };

  cargoSha256 = "sha256-y+vBHAHTe++tYOWWQ5ioFlprRfDximZE8KSGNNBSPAk=";

  cargoBuildFlags = lib.optionals withJson [ "--features" "json" ];

  cargoCheckFlags = cargoBuildFlags;

  meta = with lib; {
    description = "Lints and suggestions for the nix programming language";
    homepage = "https://github.com/nerdypepper/statix";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda nerdypepper ];
  };
}
