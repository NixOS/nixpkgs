{ lib, stdenv, fetchFromGitHub, rustPlatform
, pkg-config, curl, libgit2, openssl, Security }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-raze";
  version = "0.2.10";

  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = "v${version}";
    sha256 = "1fznh8jygzyzphw7762qc2jv0370z7qjqk1vkql0g246iqby8pq9";
  };
  sourceRoot = "source/impl";

  cargoSha256 = "0kk0dc74z95nj3drz8157cckzv30hy8x99yjfqw306xcnm6nil1m";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ curl libgit2 openssl ]
    ++ lib.optional stdenv.isDarwin Security;

  doCheck = true;

  meta = with lib; {
    description = "Generate Bazel BUILD files from Cargo dependencies";
    homepage = "https://github.com/google/cargo-raze";
    license = licenses.asl20;
    maintainers = with maintainers; [ elasticdog ];
  };
}
