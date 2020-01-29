{ lib, fetchFromGitHub, buildGoPackage }:
  
buildGoPackage rec {
  pname = "govc";
  version = "0.21.0";

  goPackagePath = "github.com/vmware/govmomi";

  subPackages = [ "govc" ];

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "vmware";
    repo = "govmomi";
    sha256 = "0mig8w0szxqcii3gihrsm8n8hzziq9l6axc5z32nw9kiy9bi4130";
  };

  meta = {
    description = "A vSphere CLI built on top of govmomi";
    homepage = https://github.com/vmware/govmomi/tree/master/govc;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nicknovitski ];
  };
}
