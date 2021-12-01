{ lib, rustPlatform, fetchFromGitHub, withJson ? true }:

rustPlatform.buildRustPackage rec {
  pname = "statix";
  # also update version of the vim plugin in pkgs/misc/vim-plugins/overrides.nix
  # the version can be found in flake.nix of the source code
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "nerdypepper";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-xFdHC7LulhDBWsbCcWeH90sR4iUhzQrShiW69/KHk0U=";
  };

  cargoSha256 = "sha256-dzDgHROlwsqwQ6pk7lrwP0eV69595l0HvF7jHSe3N/g=";

  buildFeatures = lib.optional withJson "json";

  meta = with lib; {
    description = "Lints and suggestions for the nix programming language";
    homepage = "https://github.com/nerdypepper/statix";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda nerdypepper ];
  };
}
