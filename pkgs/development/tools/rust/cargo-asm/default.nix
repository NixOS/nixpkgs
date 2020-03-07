{ stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-asm";
  version = "0.1.17";

  src = fetchFromGitHub {
    owner = "gnzlbg";
    repo = "cargo-asm";
    rev = "7f69a17e9c36dfe1f0d7080d7974c72ecc87a145";
    sha256 = "0zn5p95hsmhvk2slc9hakrpvim6l4zbpgkks2x64ndwyfmzyykws";
  };

  cargoSha256 = "1xsfwzn2b7hmb7hwgfa4ss7qfas8957gkw7zys0an9hdj5qr3ywb";

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
