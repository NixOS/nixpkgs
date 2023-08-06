{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "cloud-sql-proxy";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "GoogleCloudPlatform";
    repo = "cloud-sql-proxy";
    rev = "v${version}";
    hash = "sha256-/mXaNRTRIBIPUHY/MOHpGmpB8wBp18wwftn/EdmoffQ=";
  };

  subPackages = [ "." ];

  vendorSha256 = "sha256-VadE9E4B8BIIHGl+PN4oDl0H56xE3GQn0MxGw5fGsvM=";

  preCheck = ''
    buildFlagsArray+="-short"
  '';

  meta = with lib; {
    description = "Utility for ensuring secure connections to Google Cloud SQL instances";
    homepage = "https://github.com/GoogleCloudPlatform/cloud-sql-proxy";
    license = licenses.asl20;
    maintainers = with maintainers; [ nicknovitski totoroot ];
    mainProgram = "cloud-sql-proxy";
  };
}
