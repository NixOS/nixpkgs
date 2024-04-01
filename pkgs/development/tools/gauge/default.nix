{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gauge";
  version = "1.6.4";

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
    mainProgram = "gauge";
    homepage = "https://gauge.org";
    license = licenses.asl20;
    maintainers = [ maintainers.vdemeester ];
  };
}
