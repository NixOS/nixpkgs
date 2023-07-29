{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "rust-script";
  version = "0.30.0";

  src = fetchFromGitHub {
    owner = "fornwall";
    repo = pname;
    rev = version;
    sha256 = "sha256-H1F+sz7PLpuBgQCo/InxPStbg/S6JILjr0IZ+GEGaSM=";
  };

  cargoSha256 = "sha256-O8JveH5RzkhUVHqUSzfPOujfH3HcoRMZ455QvMFyJLI=";

  # tests require network access
  doCheck = false;

  meta = with lib; {
    description = "Run Rust files and expressions as scripts without any setup or compilation step";
    homepage = "https://rust-script.org";
    changelog = "https://github.com/fornwall/rust-script/releases/tag/${version}";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
