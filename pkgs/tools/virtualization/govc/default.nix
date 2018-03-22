{ lib, fetchFromGitHub, buildGoPackage }:
  
buildGoPackage rec {
  name = "govc-${version}";
  version = "0.16.0";

  goPackagePath = "github.com/vmware/govmomi";

  subPackages = [ "govc" ];

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "vmware";
    repo = "govmomi";
    sha256 = "09fllx7l2hsjrv1jl7g06xngjy0xwn5n5zng6x8dspgsl6kblyqp";
  };

  meta = {
    description = "A vSphere CLI built on top of govmomi";
    homepage = https://github.com/vmware/govmomi/tree/master/govc;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nicknovitski ];
  };
}
