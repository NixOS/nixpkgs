{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "miller";
  version = "6.3.0";

  src = fetchFromGitHub {
    owner = "johnkerl";
    repo = "miller";
    rev = "v${version}";
    sha256 = "sha256-5lDoJo5v6L4nkaCSyeViOeCN6cn4lBIwHYc0Jx70FFk=";
  };

  vendorSha256 = "sha256-MUffv6dRvtc4pC1vErGgUMh6B8bbVaP0avAKNamRErI=";

  subPackages = [ "cmd/mlr" ];

  meta = with lib; {
    description = "Like awk, sed, cut, join, and sort for data formats such as CSV, TSV, JSON, JSON Lines, and positionally-indexed";
    homepage    = "https://github.com/johnkerl/miller";
    license     = licenses.bsd2;
    maintainers = with maintainers; [ mstarzyk ];
    mainProgram = "mlr";
    platforms   = platforms.all;
  };
}
