{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-expand";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "dtolnay";
    repo = pname;
    rev = version;
    sha256 = "09jdqf1f8kl2c3k4cp8j3qqb96gclhncvfdwg2l3bmh5r10id9b3";
  };

  cargoSha256 = "10y54hn1q8pifgfh6nrzj0c51l3chc7ar291xfs858zdrk3qnnkj";

  meta = with lib; {
    description =
      "A utility and Cargo subcommand designed to let people expand macros in their Rust source code";
    homepage = "https://github.com/dtolnay/cargo-expand";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ xrelkd ];
  };
}
