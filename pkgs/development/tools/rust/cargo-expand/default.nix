{ stdenv, rustPlatform, fetchFromGitHub, llvmPackages, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-expand";
  version = "0.4.14";

  src = fetchFromGitHub {
    owner = "dtolnay";
    repo = pname;
    rev = version;
    sha256 = "0i59m34lav3cmrazaxfraj3jk5mdi5fgaq8p7l4s8qr1fpmmw9vy";
  };

  cargoSha256 = "1sjbcgscgvjq4qpcljrsj1dyxbr10jl6wpp27xh3bv8c2rv4bzz8";

  buildInputs = [ llvmPackages.libclang ]
    ++ stdenv.lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.Security;

  LIBCLANG_PATH = "${llvmPackages.libclang}/lib";

  meta = with stdenv.lib; {
    description = "A utility and Cargo subcommand designed to let people expand macros in their Rust source code";
    homepage = https://github.com/dtolnay/cargo-expand;
    license = with licenses; [ mit asl20 ];
    platforms = platforms.all;
    maintainers = with maintainers; [ xrelkd ];
  };
}
