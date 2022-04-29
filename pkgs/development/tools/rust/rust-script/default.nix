{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "rust-script";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "fornwall";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-WcvRkp57VyBB5gQgamFoR6wK1cRJ+3hQqixOBgeapJU=";
  };

  cargoSha256 = "sha256-qJIftByppOrT4g3sxmKRSLhxtpAW4eXWX0FhmMDJNu0=";

  # tests require network access
  doCheck = false;

  meta = with lib; {
    description = "Run Rust files and expressions as scripts without any setup or compilation step";
    homepage = "https://rust-script.org";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
