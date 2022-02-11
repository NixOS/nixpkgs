{ lib, rustPlatform, fetchFromGitHub, withJson ? true, stdenv }:

rustPlatform.buildRustPackage rec {
  pname = "statix";
  # also update version of the vim plugin in pkgs/misc/vim-plugins/overrides.nix
  # the version can be found in flake.nix of the source code
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "nerdypepper";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ibz5b+amOTlLxDlCPrC7A6rSFac3JXwiq3HMyIJwdUw=";
  };

  cargoSha256 = "sha256-MKInDGBZcOp+90cus6X2GAgjZx6M1TbSJgpUQWx60sQ=";

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
