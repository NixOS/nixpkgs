{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-expand";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "dtolnay";
    repo = pname;
    rev = version;
    sha256 = "0bdv6h3mzmv46pdyvwl0v0bg719dlsxlx378ws6vgi1cga24g37i";
  };

  cargoSha256 = "0qpihfgfqxw5fyhn124c5lbfaxr717bqf8mrbagh3vdgvk75j0qz";

  meta = with lib; {
    description =
      "A utility and Cargo subcommand designed to let people expand macros in their Rust source code";
    homepage = "https://github.com/dtolnay/cargo-expand";
    license = with licenses; [ mit asl20 ];
    platforms = platforms.all;
    maintainers = with maintainers; [ xrelkd ];
  };
}
