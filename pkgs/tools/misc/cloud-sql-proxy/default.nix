{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "cloud-sql-proxy";
  version = "1.28.1";

  src = fetchFromGitHub {
    owner = "GoogleCloudPlatform";
    repo = "cloudsql-proxy";
    rev = "v${version}";
    sha256 = "sha256-mQYzc5OPYEsxBeSRiPHvYvh8grPOgB5sWB9EBrY3a6A=";
  };

  subPackages = [ "cmd/cloud_sql_proxy" ];

  vendorSha256 = "sha256-+vuhOrUvA6W6y/6oEvJtsYixyvRzFPzpbw0Qn0AnYRI=";

  checkFlags = [ "-short" ];

  meta = with lib; {
    description = "An authenticating proxy for Second Generation Google Cloud SQL databases";
    homepage = "https://github.com/GoogleCloudPlatform/cloudsql-proxy";
    license = licenses.asl20;
    maintainers = with maintainers; [ nicknovitski ];
    mainProgram = "cloud_sql_proxy";
  };
}
