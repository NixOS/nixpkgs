{ lib, rustPlatform, fetchFromGitHub, libiconv, stdenv }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-insta";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "mitsuhiko";
    repo = "insta";
    rev = version;
    sha256 = "1qzzkhailxjqwp3rmdcpp112wn3x0gfi788vwj77pfdyclhpj0a7";
  };

  sourceRoot = "source/cargo-insta";
  cargoSha256 = "01fj2j7ibrk5dyrfkmc610lh1p6f6bgzbgivq3dsd64vslhqmabw";
  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];

  meta = with lib; {
    description = "A Cargo subcommand for snapshot testing";
    homepage = "https://github.com/mitsuhiko/insta";
    license = licenses.asl20;
    maintainers = with lib.maintainers; [ oxalica ];
  };
}
