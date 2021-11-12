{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "cloud-sql-proxy";
  version = "1.26.0";

  src = fetchFromGitHub {
    owner = "GoogleCloudPlatform";
    repo = "cloudsql-proxy";
    rev = "v${version}";
    sha256 = "sha256-Xgz8ku6szzbgL3cyiggHJYaj4aUhaqgIOUnwKUE1AeY=";
  };

  subPackages = [ "cmd/cloud_sql_proxy" ];

  vendorSha256 = "sha256-7KiLJoQ0xH35ae4NGODF4t1S9h86L0TJbCqFVm+bBmk=";

  meta = with lib; {
    description = "An authenticating proxy for Second Generation Google Cloud SQL databases";
    homepage = "https://github.com/GoogleCloudPlatform/cloudsql-proxy";
    license = licenses.asl20;
    maintainers = with maintainers; [ nicknovitski ];
  };
}
