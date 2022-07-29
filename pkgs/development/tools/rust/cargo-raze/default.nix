{ lib, stdenv, fetchFromGitHub, rustPlatform
, pkg-config, curl, libgit2, openssl, Security }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-raze";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ip0WuBn1b7uN/pAhOl5tfmToK73ZSHK7rucdtufsbCQ";
  };
  sourceRoot = "source/impl";

  cargoSha256 = "sha256-JvvUlAva4h1AkHwJW/5r5ZHVkN0Rl12uKEgMLz+5IbM";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ curl libgit2 openssl ]
    ++ lib.optional stdenv.isDarwin Security;

  # thread 'main' panicked at 'Cannot ping mock server.: "cannot send request to mock server: cannot send request to mock server: failed to resolve host name"'
  # __darwinAllowLocalNetworking does not fix the panic
  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    description = "Generate Bazel BUILD files from Cargo dependencies";
    homepage = "https://github.com/google/cargo-raze";
    license = licenses.asl20;
    maintainers = with maintainers; [ elasticdog ];
  };
}
