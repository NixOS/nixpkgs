{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage {
  pname = "regenkfs";
  version = "unstable-2020-10-17";

  src = fetchFromGitHub {
    owner = "siraben";
    repo = "regenkfs";
    rev = "652155445fc39bbe6628f6b9415b5cd6863f592f";
    sha256 = "sha256-zkwOpMNPGstn/y1l1s8blUKpBebY4Ta9hiPYxVLvG6Y=";
  };

  cargoHash = "sha256-05VmQdop4vdzw2XEvVdp9+RNmyZvay1Q7gKN2n8rDEQ=";

  buildFeatures = [ "c-undef" ];

  meta = with lib; {
    description = "Reimplementation of genkfs in Rust";
    homepage = "https://github.com/siraben/regenkfs";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben ];
    mainProgram = "regenkfs";
  };
}
