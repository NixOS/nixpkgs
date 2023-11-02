{ lib, stdenv, fetchFromGitHub, rustPlatform, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "nixdoc";
  version = "2.5.1";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nixdoc";
    rev = "v${version}";
    sha256 = "sha256-QgKzpFdzisWD6DZxs1LsKINBr/bSYQILpEu5RdcNgbc=";
  };

  cargoHash = "sha256-MztvOV1yAOgpwPYOUUZb7XHKhhhd/fvKPIFbsnMdhAQ=";

  buildInputs = lib.optionals stdenv.isDarwin [ darwin.Security ];

  meta = with lib; {
    description = "Generate documentation for Nix functions";
    homepage    = "https://github.com/nix-community/nixdoc";
    license     = [ licenses.gpl3 ];
    maintainers = [ maintainers.asymmetric ];
    platforms   = platforms.unix;
  };
}
