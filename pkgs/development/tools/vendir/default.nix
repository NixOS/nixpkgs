{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "vendir";
  version = "0.41.0";

  src = fetchFromGitHub {
    owner = "vmware-tanzu";
    repo = "carvel-vendir";
    rev = "v${version}";
    sha256 = "sha256-5CbwGwZ2dt9FVBO9sW4ZWRHiYN85rIsEKjcFUa2xJ0g=";
  };

  vendorHash = null;

  subPackages = [ "cmd/vendir" ];

  ldflags = [
    "-X carvel.dev/vendir/pkg/vendir/version.Version=${version}"
  ];

  meta = with lib; {
    description = "CLI tool to vendor portions of git repos, github releases, helm charts, docker image contents, etc. declaratively";
    mainProgram = "vendir";
    homepage = "https://carvel.dev/vendir/";
    license = licenses.asl20;
    maintainers = with maintainers; [ russell ];
  };
}
