{ lib, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  pname = "govc";
  version = "0.24.1";

  goPackagePath = "github.com/vmware/govmomi";

  subPackages = [ "govc" ];

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "vmware";
    repo = "govmomi";
    sha256 = "sha256-D2UrYdjstOxx9EAdBtAC44khp8hRf6W3+6kzytUVnOo=";
  };

  meta = {
    description = "A vSphere CLI built on top of govmomi";
    homepage = "https://github.com/vmware/govmomi/tree/master/govc";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nicknovitski ];
  };
}
