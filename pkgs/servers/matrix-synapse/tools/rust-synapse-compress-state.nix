{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "rust-synapse-compress-state";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = pname;
    rev = "v${version}";
    sha256 = "15jvkpbq6pgdc91wnni8fj435yqlwqgx3bb0vqjgsdyxs5lzalfh";
  };

  cargoSha256 = "1zdf091s0wyribsqp8l6arkablchqxmdyg2xdc57hh06p4fjiw48";

  meta = with lib; {
    description = "A tool to compress some state in a Synapse instance's database";
    homepage = "https://github.com/matrix-org/rust-synapse-compress-state";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa maralorn ];
  };
}
