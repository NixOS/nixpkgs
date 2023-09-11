{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "cloud-sql-proxy";
  version = "2.6.1";

  src = fetchFromGitHub {
    owner = "GoogleCloudPlatform";
    repo = "cloud-sql-proxy";
    rev = "v${version}";
    hash = "sha256-YbfN9ZdcxP78/dNaONBhb1UqcZYJcet+lHuKmvXk9MI=";
  };

  subPackages = [ "." ];

  vendorHash = "sha256-2Cu9o26R9y2EBUB9kLf98n2AKFOE7NE1NrcMD+8pvRY=";

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
