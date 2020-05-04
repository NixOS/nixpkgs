{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-xbuild";
  version = "0.5.29";

  src = fetchFromGitHub {
    owner = "rust-osdev";
    repo = pname;
    rev = "v${version}";
    sha256 = "05wg1xx2mcwb9cplmrpg13jimddlzmv7hf5g3vjppjp8kz2gb7zj";
  };

  cargoSha256 = "1s2xsfld29shvjzyp16y263hnbqxrq8i2557y0g09xmfm5x0jhix";

  meta = with stdenv.lib; {
    description = "Automatically cross-compiles the sysroot crates core, compiler_builtins, and alloc";
    homepage = "https://github.com/rust-osdev/cargo-xbuild";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ xrelkd ];
    platforms = platforms.all;
  };
}
