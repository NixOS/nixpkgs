{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "govc";
  version = "0.30.4";

  subPackages = [ "govc" ];

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "vmware";
    repo = "govmomi";
    sha256 = "sha256-lYiyZ2sY58bzUtqcM6WIsooLldQAxibASM7xXKAeqJM=";
  };

  vendorHash = "sha256-jbGqQITAhyBLoDa3cKU5gK+4WGgoGSCyFtzeoXx8e7k=";

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
