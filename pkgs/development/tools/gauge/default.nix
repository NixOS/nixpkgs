{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gauge";
  version = "1.6.4";

  patches = [
    # adds a check which adds an error message when trying to
    # install plugins imperatively when using the wrapper
    ./nix-check.patch
  ];

  src = fetchFromGitHub {
    owner = "getgauge";
    repo = "gauge";
    rev = "v${version}";
    hash = "sha256-Hefhhexy3Kl4fmYXlNBgZBSdOGPJefS1BjKWoblIVaw=";
  };

  vendorHash = "sha256-csS7lRTczno77LIDq2q3DeuJxQcOLr1cQf11NuWixG8=";

  excludedPackages = [ "build" "man" ];

  meta = with lib; {
    description = "Light weight cross-platform test automation";
    homepage = "https://gauge.org";
    license = licenses.asl20;
    mainProgram = "gauge";
    maintainers = with maintainers; [ vdemeester marie ];
  };
}
