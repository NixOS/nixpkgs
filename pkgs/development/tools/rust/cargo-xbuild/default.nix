{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-xbuild";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "rust-osdev";
    repo = pname;
    rev = "v${version}";
    sha256 = "0kmnwx2fg4nq009dzwk840z8n4rayvpk6hjpryczv56sjdcqm2zv";
  };

  cargoSha256 = "0vnhaf7b2ai151wjadgj7pm5hdcj7rv1ckj5mjn74r3vvds2jdn7";

  meta = with stdenv.lib; {
    description = "Automatically cross-compiles the sysroot crates core, compiler_builtins, and alloc";
    homepage = "https://github.com/rust-osdev/cargo-xbuild";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ johntitor xrelkd ];
  };
}
