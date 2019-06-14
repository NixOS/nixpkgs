{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-xbuild";
  version = "0.5.12";

  src = fetchFromGitHub {
    owner = "rust-osdev";
    repo = pname;
    rev = "v${version}";
    sha256 = "1vjsss2zrja4kpr83vw6g0hf9xdx658wjhdiymzndbcf32qrx7x1";
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
