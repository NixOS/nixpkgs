{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "checkip";
  version = "0.44.0";

  src = fetchFromGitHub {
    owner = "jreisinger";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-B+gi3BNEQUZL5McSPnSRyUssa9AhnMHswfmCrK0BP2o=";
  };

  vendorSha256 = "sha256-bFhSMjm9rqUUbCV9keeXm+yhzQMKrYKs1DbCt53J8aM=";

  # Requires network
  doCheck = false;

  meta = with lib; {
    description = "CLI tool that checks an IP address using various public services";
    homepage = "https://github.com/jreisinger/checkip";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
