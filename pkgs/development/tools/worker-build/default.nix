{ lib, stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "worker-build";
  version = "0.0.9";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "workers-rs";
    rev = "v${version}";
    sha256 = "sha256-nrvnIuLBtdMMBcYm8McOxHc/HHYDrogEG9Ii2Bevl+w=";
  };

  cargoSha256 = "sha256-xLssAmyfHr4EBQ72XZFqybA6ZI1UM2Q2kS5UWmIkteM=";

  buildAndTestSubdir = "worker-build";

  # missing some module upstream to run the tests
  doCheck = false;

  meta = with lib; {
    description = "This is a tool to be used as a custom build command for a Cloudflare Workers `workers-rs` project.";
    homepage = "https://github.com/cloudflare/worker-rs";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ happysalada ];
  };
}
