{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "rust-script";
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "fornwall";
    repo = pname;
    rev = version;
    sha256 = "sha256-WfrIl3a4lQPZWYx1+cHmvlAKD5CVSRaOMoTpHjcO+I8=";
  };

  cargoSha256 = "sha256-FQfSD4QwIDvwaGFRmunO3Zp5R2dKUCpucCvLQsXqsRo=";

  # tests require network access
  doCheck = false;

  meta = with lib; {
    description = "Run Rust files and expressions as scripts without any setup or compilation step";
    homepage = "https://rust-script.org";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
