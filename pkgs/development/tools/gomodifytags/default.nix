{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gomodifytags";
  version = "1.6.0";

  vendorSha256 = null;

  doCheck = false;

  src = fetchFromGitHub {
    owner = "fatih";
    repo = "gomodifytags";
    rev = "v${version}";
    sha256 = "1wmzl5sk5mc46njzn86007sqyyv6han058ppiw536qyhk88rzazq";
  };

  meta = {
    description = "Go tool to modify struct field tags";
    homepage = "https://github.com/fatih/gomodifytags";
    maintainers = with lib.maintainers; [ vdemeester ];
    license = lib.licenses.bsd3;
  };
}
