{ lib, fetchFromGitHub, buildGoPackage }:
  
buildGoPackage rec {
  pname = "govc";
  version = "0.23.0";

  goPackagePath = "github.com/vmware/govmomi";

  subPackages = [ "govc" ];

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "vmware";
    repo = "govmomi";
    sha256 = "05nb5xd90kbazdx4l9bw72729dh5hrcaqdi9wpf5ma7bz7mw9wzi";
  };

  meta = {
    description = "A vSphere CLI built on top of govmomi";
    homepage = "https://github.com/vmware/govmomi/tree/master/govc";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nicknovitski ];
  };
}
