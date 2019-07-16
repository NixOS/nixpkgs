{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-xbuild";
  version = "0.5.14";

  src = fetchFromGitHub {
    owner = "rust-osdev";
    repo = pname;
    rev = version;
    sha256 = "1f87rz17bdpdipc9x2j4gq1zq181gcshhn7vc9pnn6f487hz0bgq";
  };

  cargoSha256 = "1r9i79lymfwpbcx2lp509v435qpkl9bqly1ya369p41n5yprrcjv";

  meta = with stdenv.lib; {
    description = "Automatically cross-compiles the sysroot crates core, compiler_builtins, and alloc";
    homepage = "https://github.com/rust-osdev/cargo-xbuild";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ xrelkd ];
    platforms = platforms.all;
  };
}
