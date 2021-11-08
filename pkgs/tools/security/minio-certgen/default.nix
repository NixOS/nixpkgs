{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "minio-certgen";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "minio";
    repo = "certgen";
    rev = "v${version}";
    sha256 = "sha256-HtzcoEUMt3LpQNyT0wGcmc4Q70QqHx7QpjrDh4YSO/Q=";
  };

  vendorSha256 = "sha256-pQpattmS9VmO3ZIQUFn66az8GSmB4IvYhTTCFn6SUmo=";

  meta = with lib; {
    description = "A simple Minio tool to generate self-signed certificates, and provides SAN certificates with DNS and IP entries";
    downloadPage = "https://github.com/minio/certgen";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
