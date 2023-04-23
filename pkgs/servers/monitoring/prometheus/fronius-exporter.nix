{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "fronius-exporter";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "ccremer";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-BRCs7FNoZZLk7uvRNgPEJBhof1C+GCM4Pqb8HHZoZGY=";
  };

  vendorHash = "sha256-yNZk0Lb0mduhqVvG4+5Z+bV/ssQh8ujhjBvBDgToBho=";

  passthru.tests = { inherit (nixosTests.prometheus-exporters) fronius; };

  meta = with lib; {
    description = "Fronius Symo Photovoltaics exporter for prometheus";
    homepage = "https://github.com/ccremer/fronius-exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [
      _0x4A6F
    ];
  };
}
