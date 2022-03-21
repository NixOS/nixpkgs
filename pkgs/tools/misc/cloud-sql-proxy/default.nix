{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "cloud-sql-proxy";
  version = "1.29.0";

  src = fetchFromGitHub {
    owner = "GoogleCloudPlatform";
    repo = "cloudsql-proxy";
    rev = "v${version}";
    sha256 = "sha256-V/dNS/tbPPkVpgaCkGa5pfH/vj8y7mO9OQDLhgWbRCE=";
  };

  subPackages = [ "cmd/cloud_sql_proxy" ];

  vendorSha256 = "sha256-6td7rDye0sBUhDn9YARvdCgdfS/8z+VY1wYcEcUzHBs=";

  checkFlags = [ "-short" ];

  meta = with lib; {
    description = "An authenticating proxy for Second Generation Google Cloud SQL databases";
    homepage = "https://github.com/GoogleCloudPlatform/cloudsql-proxy";
    license = licenses.asl20;
    maintainers = with maintainers; [ nicknovitski ];
    mainProgram = "cloud_sql_proxy";
  };
}
