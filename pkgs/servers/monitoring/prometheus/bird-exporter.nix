{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "bird-exporter";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "czerwonk";
    repo = "bird_exporter";
    rev = version;
    sha256 = "sha256-QCnOMiAcvn0HcppGJlf3sdllApKcjHpucvk9xxD/MqE=";
  };

  vendorSha256 = "sha256-jBwaneVv1a8iIqnhDbQOnvaJdnXgO8P90Iv51IfGaM0=";

  passthru.tests = { inherit (nixosTests.prometheus-exporters) bird; };

  meta = with lib; {
    description = "Prometheus exporter for the bird routing daemon";
    homepage = "https://github.com/czerwonk/bird_exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ lukegb ];
  };
}
