{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-expand";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "dtolnay";
    repo = pname;
    rev = version;
    sha256 = "sha256-FWXSEGjTr2DewZ8NidzPdc6jhfNAUdV9qKyR7ZciWio=";
  };

  cargoSha256 = "sha256-uvTxOZPMTCd+3WQJeVfSC5mlJ487hJKs/0Dd2C8cpcM=";

  meta = with lib; {
    description =
      "A utility and Cargo subcommand designed to let people expand macros in their Rust source code";
    homepage = "https://github.com/dtolnay/cargo-expand";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ xrelkd ];
  };
}
