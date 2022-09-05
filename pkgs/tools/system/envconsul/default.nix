{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "envconsul";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "envconsul";
    rev = "v${version}";
    sha256 = "sha256-Zt4jCqHfDTxSrAIASQgUqtYgcHU9xUs025YOxGXhTAg=";
  };

  vendorSha256 = "sha256-qxt2LNPDxdiszkjSjgzP7PG26BsZYq1itiyQfy9uaVI=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/hashicorp/envconsul/version.Name=envconsul"
  ];

  meta = with lib; {
    homepage = "https://github.com/hashicorp/envconsul/";
    description = "Read and set environmental variables for processes from Consul";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.mpl20;
    maintainers = with maintainers; [ pradeepchhetri ];
  };
}
