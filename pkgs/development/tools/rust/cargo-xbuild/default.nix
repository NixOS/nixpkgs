{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-xbuild";
  version = "0.5.15";

  src = fetchFromGitHub {
    owner = "rust-osdev";
    repo = pname;
    rev = "v${version}";
    sha256 = "0ck3gwgxbg03z864bhqy8vwcpm7al17fm380zsb6ijb1q2sk2r2n";
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
