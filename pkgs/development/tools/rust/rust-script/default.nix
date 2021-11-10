{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "rust-script";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "fornwall";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-B/xh0eYRJxjjIEXdxmLz6usQvo4v/HQK5VNnnjcDBjM=";
  };

  cargoSha256 = "sha256-7qMrrs6K+mJVDHNkGQDb6abM18RyBPToseTNM7ogdQ0=";

  # tests require network access
  doCheck = false;

  meta = with lib; {
    description = "Run Rust files and expressions as scripts without any setup or compilation step";
    homepage = "https://rust-script.org";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
