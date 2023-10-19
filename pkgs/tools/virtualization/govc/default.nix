{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "govc";
  version = "0.32.0";

  subPackages = [ "govc" ];

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "vmware";
    repo = "govmomi";
    sha256 = "sha256-GnMWgN6ZxxGU/tRAPIk2cvpsBiut97iPcU9920wepxM=";
  };

  vendorHash = "sha256-mf9ZYZEmqB/47JLHn8N3VDr57SXbFLubXnwfXj682FA=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/vmware/govmomi/govc/flags.BuildVersion=${version}"
  ];

  meta = {
    description = "A vSphere CLI built on top of govmomi";
    homepage = "https://github.com/vmware/govmomi/tree/master/govc";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nicknovitski ];
  };
}
