{ lib, rustPlatform, fetchFromGitHub, stdenv, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-expand";
  version = "1.0.7";

  src = fetchFromGitHub {
    owner = "dtolnay";
    repo = pname;
    rev = version;
    sha256 = "sha256-8YppfgYa5Sd/3nPCMCgaM3A93ND0vU5eUoCW02uDkiM=";
  };

  cargoSha256 = "sha256-0lrz8awAtLuLWE6Prmi07iGfYVmNZIETv3QL55CPYHQ=";

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  meta = with lib; {
    description =
      "A utility and Cargo subcommand designed to let people expand macros in their Rust source code";
    homepage = "https://github.com/dtolnay/cargo-expand";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ xrelkd ];
  };
}
