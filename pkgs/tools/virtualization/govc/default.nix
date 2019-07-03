{ lib, fetchFromGitHub, buildGoPackage }:
  
buildGoPackage rec {
  name = "govc-${version}";
  version = "0.20.0";

  goPackagePath = "github.com/vmware/govmomi";

  subPackages = [ "govc" ];

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "vmware";
    repo = "govmomi";
    sha256 = "16pgjhlps21vk3cb5h2y0b6skq095rd8kl0618rwrz84chdnzahk";
  };

  meta = {
    description = "A vSphere CLI built on top of govmomi";
    homepage = https://github.com/vmware/govmomi/tree/master/govc;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nicknovitski ];
  };
}
