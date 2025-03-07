{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "vendir";
  version = "0.40.2";

  src = fetchFromGitHub {
    owner = "vmware-tanzu";
    repo = "carvel-vendir";
    rev = "v${version}";
    sha256 = "sha256-cGcp7bMdxZrg+4ni5kX4jEq2Aybfmonna0jM1Ux6s9Q=";
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
