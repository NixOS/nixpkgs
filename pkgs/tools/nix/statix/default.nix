{ lib, rustPlatform, fetchFromGitHub, withJson ? true, stdenv }:

rustPlatform.buildRustPackage rec {
  pname = "statix";
  # also update version of the vim plugin in pkgs/misc/vim-plugins/overrides.nix
  # the version can be found in flake.nix of the source code
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "nerdypepper";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-68ejROWcDqc4SnivFIrbsSZDqCXEo0sXSiwpro7AmgU=";
  };

  cargoSha256 = "sha256-YHA97bnGHYRwSZYZ3ZViUlRQskwLPUC26FBWQyBG5Uc=";

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
