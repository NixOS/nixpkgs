{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "minio-certgen";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "minio";
    repo = "certgen";
    rev = "v${version}";
    sha256 = "sha256-FBx4v29ZuhXwubWivIXReO5Ge/rPt1J3LbXlprC7E9c=";
  };

  vendorSha256 = null;

  meta = with lib; {
    description = "A simple Minio tool to generate self-signed certificates, and provides SAN certificates with DNS and IP entries";
    downloadPage = "https://github.com/minio/certgen";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bryanasdev000 ];
    mainProgram = "certgen";
  };
}
