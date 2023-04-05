{ lib, rustPlatform, fetchFromGitHub, stdenv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-vet";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = pname;
    rev = version;
    sha256 = "sha256-PAqpVixBdytHvSUu03OyoA1QGBxmmoeV78x6wCiCemQ=";
  };

  cargoSha256 = "sha256-dsaDpDa/BNqnL3K4a1mg3uEyM094/UO73MzJD9YaAwE=";

  buildInputs = lib.optional stdenv.isDarwin Security;

  # the test_project tests require internet access
  checkFlags = [
    "--skip=test_project"
  ];

  meta = with lib; {
    description = "A tool to help projects ensure that third-party Rust dependencies have been audited by a trusted source";
    homepage = "https://mozilla.github.io/cargo-vet";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda jk ];
  };
}
