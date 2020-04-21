{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-expand";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "dtolnay";
    repo = pname;
    rev = version;
    sha256 = "1zpnhigsa0cyr3lj0h7z2xhi01zjrnakvvrgmqz4lyf5gabh9vcg";
  };

  cargoSha256 = "1rdh1b240gcjbk3wc384x459lbp8dy9a9mgrampqjk1n115zgbzp";

  meta = with lib; {
    description =
      "A utility and Cargo subcommand designed to let people expand macros in their Rust source code";
    homepage = "https://github.com/dtolnay/cargo-expand";
    license = with licenses; [ mit asl20 ];
    platforms = platforms.all;
    maintainers = with maintainers; [ xrelkd ];
  };
}
