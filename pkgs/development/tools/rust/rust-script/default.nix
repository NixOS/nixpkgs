{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "rust-script";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "fornwall";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-CYeTt6PzVGu62/GJB+gUlOXG2bs4RV0LWECF4CN3Uic=";
  };

  cargoSha256 = "sha256-IUzaVeOTBAOo/jkDytk6qc7VatKX75l1yZy99iSIqyE=";

  # tests require network access
  doCheck = false;

  meta = with lib; {
    description = "Run Rust files and expressions as scripts without any setup or compilation step";
    homepage = "https://rust-script.org";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
