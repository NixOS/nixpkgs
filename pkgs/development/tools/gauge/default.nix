{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gauge";
  version = "1.6.6";

  patches = [
    # adds a check which adds an error message when trying to
    # install plugins imperatively when using the wrapper
    ./nix-check.patch
  ];

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
    maintainers = with maintainers; [ vdemeester marie ];
  };
}
