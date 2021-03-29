{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "vendir";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "vmware-tanzu";
    repo = "carvel-vendir";
    rev = "v${version}";
    sha256 = "14yd14z4666alwsn2jhcvg2kijvw4qjr4h3gikchiir38w520fs9";
  };

  vendorSha256 = null;

  subPackages = [ "cmd/vendir" ];

  meta = with lib; {
    description = "CLI tool to vendor portions of git repos, github releases, helm charts, docker image contents, etc. declaratively";
    homepage = "https://carvel.dev/vendir/";
    license = licenses.asl20;
    maintainers = with maintainers; [ russell ];
  };
}
