{ lib, rustPlatform, fetchFromGitHub, withJson ? true, stdenv }:

rustPlatform.buildRustPackage rec {
  pname = "statix";
  # also update version of the vim plugin in
  # pkgs/applications/editors/vim/plugins/overrides.nix
  # the version can be found in flake.nix of the source code
  version = "0.5.6";

  src = fetchFromGitHub {
    owner = "nerdypepper";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-OQk80eTUufVUbYvZ38el2lmkgkU+5gr0hLTrBvzIp4A=";
  };

  cargoSha256 = "sha256-j+FcV5JtO66Aa0ncIUfjuWtqnMmFb7zW7rNXttYBUU4=";

  buildFeatures = lib.optional withJson "json";

  # tests are failing on darwin
  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    description = "Lints and suggestions for the nix programming language";
    homepage = "https://github.com/nerdypepper/statix";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda nerdypepper ];
  };
}
