{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "cloud-sql-proxy";
  version = "1.25.0";

  src = fetchFromGitHub {
    owner = "GoogleCloudPlatform";
    repo = "cloudsql-proxy";
    rev = "v${version}";
    sha256 = "0vz5fm1bgh2g7b320hchpfb4iql1src1rpm7324sqcd26p7w3mnl";
  };

  subPackages = [ "cmd/cloud_sql_proxy" ];

  vendorSha256 = "04y6zx3jdyj07d68a4vk4p5rzvvjnvdwk9kkipmlmqg1xqwlb84m";

  meta = with lib; {
    description = "An authenticating proxy for Second Generation Google Cloud SQL databases";
    homepage = "https://github.com/GoogleCloudPlatform/cloudsql-proxy";
    license = licenses.asl20;
    maintainers = with maintainers; [ nicknovitski ];
  };
}
