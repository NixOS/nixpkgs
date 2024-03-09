{ lib, fetchFromGitHub, buildGoModule, nixosTests, fetchpatch }:

buildGoModule rec {
  pname = "prometheus-nextcloud-exporter";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "xperimental";
    repo = "nextcloud-exporter";
    rev = "v${version}";
    sha256 = "sha256-OiuhxawEpD29EhbzA9DYeJ1J1/uMQGgBTZR9m/5egHI=";
  };

  vendorHash = "sha256-QlMj4ATpJATlQAsrxIHG/1vrD5E/4brsda3BoGGzDgk=";

  passthru.tests = { inherit (nixosTests.prometheus-exporters) nextcloud; };

  meta = with lib; {
    description = "Prometheus exporter for Nextcloud servers";
    homepage = "https://github.com/xperimental/nextcloud-exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ willibutz ];
    mainProgram = "nextcloud-exporter";
  };
}
