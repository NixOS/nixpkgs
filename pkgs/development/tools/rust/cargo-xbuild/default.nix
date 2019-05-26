{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-xbuild";
  version = "0.5.9";

  src = fetchFromGitHub {
    owner = "rust-osdev";
    repo = pname;
    rev = "v${version}";
    sha256 = "0c4gls25vvkh4hw8apic03zb54m1v69n9ycwcp49c73ky8lrn0vj";
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
