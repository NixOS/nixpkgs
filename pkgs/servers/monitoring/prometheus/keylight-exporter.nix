{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "keylight-exporter";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "mdlayher";
    repo = "keylight_exporter";
    rev = "v${version}";
    sha256 = "sha256-yI1mmEb5SP2lbP37CpPxYITJL/nvd/mIwxB0RIQRe4I=";
  };

  vendorHash = "sha256-0QSsGgokErRNIHQIjZQn5t1dvc306uZck8uLSgjcrck=";

  passthru.tests = { inherit (nixosTests.prometheus-exporters) keylight; };

  meta = with lib; {
    homepage = "https://github.com/mdlayher/keylight_exporter";
    description = "Prometheus exporter for Elgato Key Light devices";
    license = licenses.mit;
    maintainers = with maintainers; [ mdlayher ];
  };
}
