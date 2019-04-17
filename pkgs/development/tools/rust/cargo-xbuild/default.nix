{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-xbuild";
  version = "0.5.8";

  src = fetchFromGitHub {
    owner = "rust-osdev";
    repo = pname;
    rev = "v${version}";
    sha256 = "1ckrvgdjwkxvy3rc6kix9maynn87al0n7lsjshc9mdmkyvvx8h55";
  };

  cargoSha256 = "077qiqm470iqcgxqjzbmzxikxd5862vyg788hacli4yzpvyaq9r9";

  meta = with stdenv.lib; {
    description = "Automatically cross-compiles the sysroot crates core, compiler_builtins, and alloc";
    homepage = https://github.com/rust-osdev/cargo-xbuild;
    license = with licenses; [ mit asl20 ];
    platforms = platforms.all;
  };
}
