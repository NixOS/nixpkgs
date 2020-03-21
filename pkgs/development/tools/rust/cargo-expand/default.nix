{ stdenv, rustPlatform, fetchFromGitHub, llvmPackages, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-expand";
  version = "0.4.18";

  src = fetchFromGitHub {
    owner = "dtolnay";
    repo = pname;
    rev = version;
    sha256 = "1dhrzfy1ii2vg8psvz9rrgk0blj5bl64ghr0z44vh5y0kxn9v62p";
  };

  cargoSha256 = "13ib0binyw1rzxjg59ly3ahyr53wdq3z7wfp11gd61kzwz34gs9d";

  buildInputs = [ llvmPackages.libclang ]
    ++ stdenv.lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.Security;

  LIBCLANG_PATH = "${llvmPackages.libclang}/lib";

  meta = with stdenv.lib; {
    description = "A utility and Cargo subcommand designed to let people expand macros in their Rust source code";
    homepage = "https://github.com/dtolnay/cargo-expand";
    license = with licenses; [ mit asl20 ];
    platforms = platforms.all;
    maintainers = with maintainers; [ xrelkd ];
  };
}
