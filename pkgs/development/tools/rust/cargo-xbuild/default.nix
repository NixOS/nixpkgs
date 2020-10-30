{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-xbuild";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "rust-osdev";
    repo = pname;
    rev = "v${version}";
    sha256 = "01whdjryz6zjsk4149h72w5xdjnkpcn5daf0xnsb59b0q38hjgg9";
  };

  cargoSha256 = "1gcixzxca1yi4rvy55s986my6j0vx7n6fm1g5r4v4w0zgzlz4d89";

  meta = with stdenv.lib; {
    description = "Automatically cross-compiles the sysroot crates core, compiler_builtins, and alloc";
    homepage = "https://github.com/rust-osdev/cargo-xbuild";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ johntitor xrelkd ];
  };
}
