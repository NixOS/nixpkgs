{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, libiconv
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-expand";
  version = "1.0.30";

  src = fetchFromGitHub {
    owner = "dtolnay";
    repo = pname;
    rev = version;
    sha256 = "sha256-H97B48SrcUTgY7hLMx9NUc4VUENBZtGMwpI6ijTUB08=";
  };

  cargoSha256 = "sha256-OCCBmcKNotsDXAAu0A8HCmniDLofkp2MmBm+k3C0ZJ4=";

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  meta = with lib; {
    description =
      "A utility and Cargo subcommand designed to let people expand macros in their Rust source code";
    homepage = "https://github.com/dtolnay/cargo-expand";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ xrelkd ];
  };
}
