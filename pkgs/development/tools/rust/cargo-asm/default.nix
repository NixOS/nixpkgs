{ stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  name = "cargo-asm-${version}";
  version = "0.1.16";

  src = fetchFromGitHub {
    owner = "gnzlbg";
    repo = "cargo-asm";
    rev = "7d0ece74657edb002bd8530227b829b31fd19dcd";
    sha256 = "0mzbh5zw5imlaagm5zjbjk9kqdnglm398rxkqisd22h6569ppqpc";
  };

  cargoSha256 = "1m2j6i8hc8isdlj77gv9m6sk6q0x3bvzpva2k16g27i1ngy1989b";

  buildInputs = stdenv.lib.optional stdenv.isDarwin Security;

  # Test checks against machine code output, which fails with some
  # LLVM/compiler versions.
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Display the assembly or LLVM-IR generated for Rust source code";
    homepage = https://github.com/gnzlbg/cargo-asm;
    license = licenses.mit;
    maintainers = [ maintainers.danieldk ];
    platforms = platforms.all;
  };
}
