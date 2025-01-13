{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  Security,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-asm";
  version = "2019-12-24";

  src = fetchFromGitHub {
    owner = "gnzlbg";
    repo = "cargo-asm";
    rev = "577f890ebd4a09c8265710261e976fe7bfce8668";
    sha256 = "1f6kzsmxgdms9lq5z9ynnmxymk9k2lzlp3caa52wqjvdw1grw0rb";
  };

  cargoHash = "sha256-QsaOFman+VBSIAbCalW63I3QXY0uECZy9+ufOKhSQrA=";

  buildInputs = lib.optional stdenv.hostPlatform.isDarwin Security;

  # Test checks against machine code output, which fails with some
  # LLVM/compiler versions.
  doCheck = false;

  meta = with lib; {
    description = "Display the assembly or LLVM-IR generated for Rust source code";
    homepage = "https://github.com/gnzlbg/cargo-asm";
    license = licenses.mit;
    maintainers = [ ];
  };
}
