{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gauge";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "getgauge";
    repo = "gauge";
    rev = "v${version}";
    hash = "sha256-gdqb9atksAU2bjNdoOfxb3XYl3H/1F51Xnfnm78J3CQ=";
  };

  vendorHash = "sha256-PmidtbtX+x5cxuop+OCrfdPP5EiJnyvFyxHveGVGAEo=";

  excludedPackages = [ "build" "man" ];

  meta = with lib; {
    description = "Light weight cross-platform test automation";
    homepage = "https://gauge.org";
    license = licenses.asl20;
    maintainers = [ maintainers.vdemeester ];
  };
}
