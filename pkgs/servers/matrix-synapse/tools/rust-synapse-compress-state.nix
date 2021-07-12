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

  cargoSha256 = "173nylp9xj88cm42yggj41iqvgb25s3awhf1dqssy8f1zyw2cf3d";

  meta = with lib; {
    description = "A tool to compress some state in a Synapse instance's database";
    homepage = "https://github.com/matrix-org/rust-synapse-compress-state";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa maralorn ];
  };
}
