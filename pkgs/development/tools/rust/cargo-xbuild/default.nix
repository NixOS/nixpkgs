{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-xbuild";
  version = "0.5.11";

  src = fetchFromGitHub {
    owner = "rust-osdev";
    repo = pname;
    rev = "v${version}";
    sha256 = "04vgb443bmrfklvzhjfidpi3pp2svbc3bwq674m9fn7sbdp6rnwm";
  };

  cargoSha256 = "1r9i79lymfwpbcx2lp509v435qpkl9bqly1ya369p41n5yprrcjv";

  meta = with stdenv.lib; {
    description = "Automatically cross-compiles the sysroot crates core, compiler_builtins, and alloc";
    homepage = https://github.com/rust-osdev/cargo-xbuild;
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ xrelkd ];
    platforms = platforms.all;
  };
}
