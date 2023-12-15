{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "fritzbox-exporter";
  version = "unstable-2021-04-13";

  src = fetchFromGitHub {
    rev = "fd36539bd7db191b3734e17934b5f1e78e4e9829";
    owner = "mxschmitt";
    repo = "fritzbox_exporter";
    hash = "sha256-NtxgOGoFZjvNCn+alZF9Ngen4Z0nllR/NTgY5ixrL3E=";
  };

  vendorHash = "sha256-VhQAEVxRJjIzFP67LUKhfGxdUbTQB7UCK8/JKwpoy0w=";

  subPackages = [ "cmd/exporter" ];

  passthru.tests = { inherit (nixosTests.prometheus-exporters) fritzbox; };

  meta = with lib; {
    description = "Prometheus Exporter for FRITZ!Box (TR64 and UPnP)";
    homepage = "https://github.com/mxschmitt/fritzbox_exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ bachp flokli sbruder ];
  };
}
