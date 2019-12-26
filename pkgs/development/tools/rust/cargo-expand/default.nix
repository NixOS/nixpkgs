{ stdenv, rustPlatform, fetchFromGitHub, llvmPackages, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-expand";
  version = "0.4.16";

  src = fetchFromGitHub {
    owner = "dtolnay";
    repo = pname;
    rev = version;
    sha256 = "0cf539y20hlwxbk0zfs1and99hkb0fqg7m3a6dfd80hwx0dm0xmx";
  };

  cargoSha256 = "1bspciy7sfx887hwxmckrnjy7b6kpy6g51yraw25yl302mzzng21";

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
