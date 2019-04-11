{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  name = "cargo-xbuild-${version}";
  version = "0.5.7";

  src = fetchFromGitHub {
    owner = "rust-osdev";
    repo = "cargo-xbuild";
    rev = "v${version}";
    sha256 = "11hjyf16m4ri4c912jsdmqq88xcrys119135nz48y5p7b4yp0s7a";
  };

  cargoSha256 = "077qiqm470iqcgxqjzbmzxikxd5862vyg788hacli4yzpvyaq9r9";

  meta = with stdenv.lib; {
    description = "Automatically cross-compiles the sysroot crates core, compiler_builtins, and alloc";
    homepage = https://github.com/rust-osdev/cargo-xbuild;
    license = with licenses; [ mit asl20 ];
    platforms = platforms.all;
  };
}
