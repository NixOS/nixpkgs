{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gauge";
  version = "1.6.6";

  src = fetchFromGitHub {
    owner = "getgauge";
    repo = "gauge";
    rev = "v${version}";
    hash = "sha256-u64LEDWktnBqGmey1TGdpVerjBsgyyRKJKeAJU3ysZs=";
  };

  vendorHash = "sha256-RC3oS4nD291p8BSiWZUmsej/XuadaR7Xz1+bEfZL3Oc=";

  excludedPackages = [ "build" "man" ];

  meta = with lib; {
    description = "Light weight cross-platform test automation";
    mainProgram = "gauge";
    homepage = "https://gauge.org";
    license = licenses.asl20;
    maintainers = [ maintainers.vdemeester ];
  };
}
