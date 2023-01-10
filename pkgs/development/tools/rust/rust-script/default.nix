{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "rust-script";
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "fornwall";
    repo = pname;
    rev = version;
    sha256 = "sha256-R9L53ThJKf68M4idNiWfO6fUDJNqiyrzCmdbEvo8OMM=";
  };

  cargoSha256 = "sha256-hi0jtI6KtvBjyhhOEEE1x2l7DSIAC4tkRIF9SLFwFQI=";

  # tests require network access
  doCheck = false;

  meta = with lib; {
    description = "Run Rust files and expressions as scripts without any setup or compilation step";
    homepage = "https://rust-script.org";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
