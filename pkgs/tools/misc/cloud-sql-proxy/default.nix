<<<<<<< HEAD
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
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  preCheck = ''
    buildFlagsArray+="-short"
  '';

  meta = with lib; {
<<<<<<< HEAD
    description = "Utility for ensuring secure connections to Google Cloud SQL instances";
    homepage = "https://github.com/GoogleCloudPlatform/cloud-sql-proxy";
    license = licenses.asl20;
    maintainers = with maintainers; [ nicknovitski totoroot ];
    mainProgram = "cloud-sql-proxy";
=======
    description = "An authenticating proxy for Second Generation Google Cloud SQL databases";
    homepage = "https://github.com/GoogleCloudPlatform/cloudsql-proxy";
    license = licenses.asl20;
    maintainers = with maintainers; [ nicknovitski ];
    mainProgram = "cloud_sql_proxy";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
