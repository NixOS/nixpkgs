{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "google-cloud-sql-proxy";
  version = "2.8.1";

  src = fetchFromGitHub {
    owner = "GoogleCloudPlatform";
    repo = "cloud-sql-proxy";
    rev = "v${version}";
    hash = "sha256-7BkzDfAXc06pEDz2gHwlJ2HKmWWkqbVwyre8NrQHY6M=";
  };

  subPackages = [ "." ];

  vendorHash = "sha256-9xe/4yMkCSD7Tfm3CWvN940odeT67HPGbBAimNOGgIc=";

  preCheck = ''
    buildFlagsArray+="-short"
  '';

  meta = with lib; {
    description = "Utility for ensuring secure connections to Google Cloud SQL instances";
    longDescription = ''
      The Cloud SQL Auth Proxy is a utility for ensuring secure connections to your Cloud SQL instances.
      It provides IAM authorization, allowing you to control who can connect to your instance through IAM permissions,
      and TLS 1.3 encryption, without having to manage certificates.
      See the [Connecting Overview](https://cloud.google.com/sql/docs/mysql/connect-overview) page for more information
      on connecting to a Cloud SQL instance, or the [About the Proxy](https://cloud.google.com/sql/docs/mysql/sql-proxy)
      page for details on how the Cloud SQL Proxy works.
    '';
    homepage = "https://github.com/GoogleCloudPlatform/cloud-sql-proxy";
    license = licenses.asl20;
    maintainers = with maintainers; [ nicknovitski totoroot ];
    mainProgram = "cloud-sql-proxy";
  };
}
