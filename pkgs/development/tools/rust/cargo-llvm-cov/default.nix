{ lib, rustPlatform, fetchCrate, fetchFromGitHub, libllvm, makeBinaryWrapper }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-llvm-cov";
  version = "0.4.14";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-DY5eBSx/PSmKaG7I6scDEbyZQ5hknA/pfl0KjTNqZlo=";
  };

  postPatch = ''
    rm tests/test.rs
  '';

  nativeBuildInputs = [ makeBinaryWrapper ];
  buildInputs = [ libllvm ];

  LLVM_COV = "${rustPlatform.rust.rustc.llvmPackages.llvm}/bin/llvm-cov";
  LLVM_PROFDATA = "${rustPlatform.rust.rustc.llvmPackages.llvm}/bin/llvm-profdata";

  postInstall = ''
    wrapProgram $out/bin/cargo-llvm-cov \
      --set LLVM_COV "${rustPlatform.rust.rustc.llvmPackages.llvm}/bin/llvm-cov" \
      --set LLVM_PROFDATA "${rustPlatform.rust.rustc.llvmPackages.llvm}/bin/llvm-profdata"
  '';

  cargoSha256 = "sha256-MGI1wV0QEZRxea6Q3fh2TJVPmI4eb9O6/DwpKkWrToE=";

  meta = with lib; {
    description = "Cargo subcommand to gather source-based code coverage using LLVM";
    homepage = "https://github.com/taiki-e/cargo-llvm-cov";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ DieracDelta matthiasbeyer ];
  };
}
