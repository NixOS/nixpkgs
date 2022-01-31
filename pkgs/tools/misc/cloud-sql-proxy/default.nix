{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "cloud-sql-proxy";
  version = "1.27.1";

  src = fetchFromGitHub {
    owner = "GoogleCloudPlatform";
    repo = "cloudsql-proxy";
    rev = "v${version}";
    sha256 = "sha256-xVPs7D639KY2ryDZpivineH4yZSNXi78FWk2SFKX1sk=";
  };

  subPackages = [ "cmd/cloud_sql_proxy" ];

  vendorSha256 = "sha256-913GJ/rPvDavQQMqDDTe4gBXziPPeQRPpUUG3DAz96g=";

  checkFlags = [ "-short" ];

  meta = with lib; {
    description = "An authenticating proxy for Second Generation Google Cloud SQL databases";
    homepage = "https://github.com/GoogleCloudPlatform/cloudsql-proxy";
    license = licenses.asl20;
    maintainers = with maintainers; [ nicknovitski ];
    mainProgram = "cloud_sql_proxy";
  };
}
