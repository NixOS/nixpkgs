{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-expand";
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "dtolnay";
    repo = pname;
    rev = version;
    sha256 = "sha256-6FjFG4RYvmsV/W7OMxj1ZWvruwUeP9Nvsdiv8toZmTk=";
  };

  cargoSha256 = "sha256-C9lpA2n7EI7Ga3Nnj80dkvbZmqjuxf0wjoQUEr0N8FE=";

  meta = with lib; {
    description =
      "A utility and Cargo subcommand designed to let people expand macros in their Rust source code";
    homepage = "https://github.com/dtolnay/cargo-expand";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ xrelkd ];
  };
}
