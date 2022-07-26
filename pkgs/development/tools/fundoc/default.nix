{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "fundoc";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "csssr";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-qmsr4bhErpMzS71NhLep0EWimZb/S3aEhMbeBNa5y8E=";
  };

  cargoSha256 = "sha256-G2KRjkccS/rfrb7BtotbG6L4WaVnfwY1UEXLnVBLSzM=";

  meta = with lib; {
    description = "Language agnostic documentation generator";
    homepage = "https://github.com/csssr/fundoc";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
