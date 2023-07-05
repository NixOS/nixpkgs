{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "minio-certgen";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "minio";
    repo = "certgen";
    rev = "v${version}";
    sha256 = "sha256-qi+SeNLW/jE2dGar4Lf16TKRT3ZTmWB/j8EsnoyrdxI=";
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
