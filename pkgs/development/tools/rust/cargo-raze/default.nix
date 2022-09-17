{ lib, stdenv, fetchFromGitHub, rustPlatform
, pkg-config, curl, libgit2, openssl, Security }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-raze";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = "v${version}";
    sha256 = "161m4y6i4sgqi9mg3f3348f5cr0m45vhix4a4bcw54wnmhiklnnl";
  };
  sourceRoot = "source/impl";

  cargoSha256 = "1vlywdq0bx6b1k3w1grisca0hvv2s4s88yxq7bil8nhm5ghjgxdr";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libgit2
    openssl
    (curl.override { inherit openssl; })
  ]
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
