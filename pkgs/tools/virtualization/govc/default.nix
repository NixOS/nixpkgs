{ lib, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  pname = "govc";
  version = "0.23.1";

  goPackagePath = "github.com/vmware/govmomi";

  subPackages = [ "govc" ];

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "vmware";
    repo = "govmomi";
    sha256 = "05f6i7v8v9g3w3cmz8c952djl652mj6qcwjx9iyl23h6knd1d9b1";
  };

  meta = {
    description = "A vSphere CLI built on top of govmomi";
    homepage = "https://github.com/vmware/govmomi/tree/master/govc";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nicknovitski ];
  };
}
