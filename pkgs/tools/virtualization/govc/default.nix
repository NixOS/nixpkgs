{ lib, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  pname = "govc";
  version = "0.25.0";

  goPackagePath = "github.com/vmware/govmomi";

  subPackages = [ "govc" ];

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "vmware";
    repo = "govmomi";
    sha256 = "sha256-Ri8snbmgcAZmdumKzBl3P6gf/eZgwdgg7V+ijyeZjks=";
  };

  meta = {
    description = "A vSphere CLI built on top of govmomi";
    homepage = "https://github.com/vmware/govmomi/tree/master/govc";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nicknovitski ];
  };
}
