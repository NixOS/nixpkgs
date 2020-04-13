{ stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-asm";
  version = "2019-12-24";

  src = fetchFromGitHub {
    owner = "gnzlbg";
    repo = "cargo-asm";
    rev = "577f890ebd4a09c8265710261e976fe7bfce8668";
    sha256 = "1f6kzsmxgdms9lq5z9ynnmxymk9k2lzlp3caa52wqjvdw1grw0rb";
  };

  cargoSha256 = "0d797cisiydblh64vqpfdjf37wmxrvs77phdrqh582lbrvnfhx2j";

  buildInputs = stdenv.lib.optional stdenv.isDarwin Security;

  # Test checks against machine code output, which fails with some
  # LLVM/compiler versions.
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Display the assembly or LLVM-IR generated for Rust source code";
    homepage = "https://github.com/gnzlbg/cargo-asm";
    license = licenses.mit;
    maintainers = [ maintainers.danieldk ];
    platforms = platforms.all;
  };
}
