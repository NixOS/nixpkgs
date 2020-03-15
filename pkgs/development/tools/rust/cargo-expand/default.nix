{ stdenv, rustPlatform, fetchFromGitHub, llvmPackages, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-expand";
  version = "0.4.17";

  src = fetchFromGitHub {
    owner = "dtolnay";
    repo = pname;
    rev = version;
    sha256 = "043adbvc1slswwygibgghfl2ryry3ja1x3zjz39qqv63f81pd5id";
  };

  cargoSha256 = "0kwpc62nwjjhlh3rd5d27sjv0p53q5gj0gky9xx9khxy8xazbh91";

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
