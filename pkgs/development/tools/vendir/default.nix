{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "vendir";
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "vmware-tanzu";
    repo = "carvel-vendir";
    rev = "v${version}";
    sha256 = "sha256-LvpzynT+ibrE1F1uv7X0pVtzOrVFIxFqbZwM04e1Do0=";
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
