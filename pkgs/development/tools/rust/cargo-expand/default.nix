{ stdenv, rustPlatform, fetchFromGitHub, llvmPackages, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-expand";
  version = "0.4.19";

  src = fetchFromGitHub {
    owner = "dtolnay";
    repo = pname;
    rev = version;
    sha256 = "15izqd6nbpxjjymdmcpzjmaiygs1vdrpg9cw1nzmrkb8fc4h5ch5";
  };

  cargoSha256 = "0sbpymxhhwxg13w9821b17nda6p3ycqr81i7bj4fxil0n3sb910h";

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
