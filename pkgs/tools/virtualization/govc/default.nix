{ lib, fetchFromGitHub, buildGoPackage }:
  
buildGoPackage rec {
  pname = "govc";
  version = "0.22.1";

  goPackagePath = "github.com/vmware/govmomi";

  subPackages = [ "govc" ];

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "vmware";
    repo = "govmomi";
    sha256 = "1z4am6143jrrls0023flnqgadm1z9p60w09cp1j5pnslm60vvw78";
  };

  meta = {
    description = "A vSphere CLI built on top of govmomi";
    homepage = "https://github.com/vmware/govmomi/tree/master/govc";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nicknovitski ];
  };
}
