{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "rust-script";
  version = "0.32.0";

  src = fetchFromGitHub {
    owner = "fornwall";
    repo = pname;
    rev = version;
    sha256 = "sha256-VyiVa1aeJslH1Vkg0TvON7VDiJVMIIbrlmx2FRDz75o=";
  };

  cargoSha256 = "sha256-K7wT5Og1nx+UcsehLbpUx0NlvoaicMDd02SkUoAncwI=";

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
