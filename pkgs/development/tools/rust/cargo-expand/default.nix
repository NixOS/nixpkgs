{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, libiconv
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-expand";
  version = "1.0.16";

  src = fetchFromGitHub {
    owner = "dtolnay";
    repo = pname;
    rev = version;
    sha256 = "sha256-NhBUN+pf+j/4IozFDEb+XZ1ijSk6dNvCANyez823a0c=";
  };

  cargoSha256 = "sha256-7rqtxyoo1SQ7Rae04+b+B0JgCKeW0p1j7bZzPpJ8+ks=";

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  meta = with lib; {
    description =
      "A utility and Cargo subcommand designed to let people expand macros in their Rust source code";
    homepage = "https://github.com/dtolnay/cargo-expand";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ xrelkd ];
  };
}
