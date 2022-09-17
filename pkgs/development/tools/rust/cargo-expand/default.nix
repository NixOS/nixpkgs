{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, libiconv
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-expand";
  version = "1.0.31";

  src = fetchFromGitHub {
    owner = "dtolnay";
    repo = pname;
    rev = version;
    sha256 = "sha256-zyh5Tcs0RbZebiLfl9bIH5Ua5cizJPDlNuoVQhW3I/c=";
  };

  cargoSha256 = "sha256-WMIgBtZowpXElTradzgGjN/TQxDn9RzS7hBKfFAlFEM=";

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  meta = with lib; {
    description =
      "A utility and Cargo subcommand designed to let people expand macros in their Rust source code";
    homepage = "https://github.com/dtolnay/cargo-expand";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ xrelkd ];
  };
}
