{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-xbuild";
  version = "0.5.21";

  src = fetchFromGitHub {
    owner = "rust-osdev";
    repo = pname;
    rev = "v${version}";
    sha256 = "08mpnj3l6bcm1jg22lw1gcs0lkm4320fwl4p5y1s44w64963kzf7";
  };

  cargoSha256 = "1pj4x8y5vfpnn8vhxqqm3vicn29870r3jh0b17q3riq4vz1a2afp";

  meta = with stdenv.lib; {
    description = "Automatically cross-compiles the sysroot crates core, compiler_builtins, and alloc";
    homepage = "https://github.com/rust-osdev/cargo-xbuild";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ xrelkd ];
    platforms = platforms.all;
  };
}
