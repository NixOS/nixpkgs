{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "govc";
  version = "0.33.1";

  subPackages = [ "govc" ];

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "vmware";
    repo = "govmomi";
    sha256 = "sha256-5zFyOWfVxQL/QveOlX4Xkg8FBwo8mZzR7ea2IacSrS4=";
  };

  vendorHash = "sha256-DBcovHOOfIy4dfi8U9zaCUzz5Zz8oIG44JCqMKtdxgg=";

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
    mainProgram = "govc";
  };
}
