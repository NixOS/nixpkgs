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

  cargoSha256 = "0mx01h2zv7mpyi8s1545b7hjxn9aslzpbngrq4ii9rfqznz3r8k9";

  meta = with lib; {
    description =
      "A utility and Cargo subcommand designed to let people expand macros in their Rust source code";
    homepage = "https://github.com/dtolnay/cargo-expand";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ xrelkd ];
  };
}
