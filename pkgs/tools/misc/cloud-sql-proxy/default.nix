{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "cloud-sql-proxy";
  version = "1.31.2";

  src = fetchFromGitHub {
    owner = "GoogleCloudPlatform";
    repo = "cloudsql-proxy";
    rev = "v${version}";
    sha256 = "sha256-wlMwl1S9WKtCoruKhMVK1197/3/OWhvvXTT1tH/yPlI=";
  };

  subPackages = [ "cmd/cloud_sql_proxy" ];

  vendorSha256 = "sha256-OMvu0LCYv0Z03ZM2o8UZx/Su2rdvTJp5DUZa8/MtQSc=";

  preCheck = ''
    buildFlagsArray+="-short"
  '';

  meta = with lib; {
    description = "An authenticating proxy for Second Generation Google Cloud SQL databases";
    homepage = "https://github.com/GoogleCloudPlatform/cloudsql-proxy";
    license = licenses.asl20;
    maintainers = with maintainers; [ nicknovitski ];
    mainProgram = "cloud_sql_proxy";
  };
}
