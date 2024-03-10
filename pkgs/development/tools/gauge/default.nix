{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gauge";
  version = "1.6.3";

  src = fetchFromGitHub {
    owner = "getgauge";
    repo = "gauge";
    rev = "v${version}";
    hash = "sha256-ymnyoQRMr3s74PnDSmXCoWGSMBhxy/CRDpRvEZHOrFU=";
  };

  vendorHash = "sha256-5kBjxhmBrC5ZzD7CSzRvIzQrJYRRU/X+n9L9JPvyJkY=";

  excludedPackages = [ "build" "man" ];

  meta = with lib; {
    description = "Light weight cross-platform test automation";
    homepage = "https://gauge.org";
    license = licenses.asl20;
    maintainers = [ maintainers.vdemeester ];
  };
}
