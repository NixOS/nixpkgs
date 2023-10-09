{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "cloud-sql-proxy";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "GoogleCloudPlatform";
    repo = "cloud-sql-proxy";
    rev = "v${version}";
    hash = "sha256-4PB9Eaqb8teF+gmiHD2VAIFnxqiK2Nb0u+xSNAM8iMs=";
  };

  subPackages = [ "." ];

  vendorHash = "sha256-LaI7IdSyB7ETTjqIcIPDf3noEbvwlN3+KqrkSm8B6m8=";

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
