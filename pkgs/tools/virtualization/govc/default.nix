{ lib, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  pname = "govc";
  version = "0.24.0";

  goPackagePath = "github.com/vmware/govmomi";

  subPackages = [ "govc" ];

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "vmware";
    repo = "govmomi";
    sha256 = "sha256-Urfrkeqbl0+GB2Vr2IfekiilRvGcG0vGO5MGeZcP4C8=";
  };

  meta = {
    description = "A vSphere CLI built on top of govmomi";
    homepage = "https://github.com/vmware/govmomi/tree/master/govc";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nicknovitski ];
  };
}
