{ lib, rustPlatform, libllvm }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-llvm-cov";
  version = "0.3.0";

  doCheck = false;

  buildInputs = [ libllvm ];

  src = builtins.fetchTarball {
    url = "https://crates.io/api/v1/crates/${pname}/${version}/download";
    sha256 = "sha256:0iswa2cdaf2123vfc42yj9l8jx53k5jm2y51d4xqc1672hi4620l";
  };

  cargoSha256 = "sha256-RzIkW/eytU8ZdZ18x0sGriJ2xvjVW+8hB85In12dXMg=";
  meta = with lib; {
    description = "Cargo llvm cov generates code coverage via llvm.";
    homepage = "https://github.com/taiki-e/cargo-llvm-cov";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ DieracDelta ];
  };
}
