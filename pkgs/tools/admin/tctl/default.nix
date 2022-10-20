{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-tctl";
  version = "1.16.3";

  src = fetchFromGitHub {
    owner = "temporalio";
    repo = "tctl";
    rev = "v${version}";
    sha256 = "sha256-GZTCxHs2/HeQIYRkhGzNYYyCd/vcGRey2lsFU7fV4gM=";
  };

  vendorSha256 = "sha256-9bgovXVj+qddfDSI4DTaNYH4H8Uc4DZqeVYG5TWXTNw=";

  subPackages = [ "cmd/tctl" ];

  meta = with lib; {
    homepage = "https://github.com/temporalio/tctl";
    description = "Temporal CLI to perform various tasks on a Temporal Server";
    maintainers = with maintainers; [ justinmir ];
    license = licenses.mit;
    mainProgram = "tctl";
  };
}
