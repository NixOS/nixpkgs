{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "bird-exporter";
  version = "1.2.6";

  src = fetchFromGitHub {
    owner = "czerwonk";
    repo = "bird_exporter";
    rev = version;
    sha256 = "sha256-zQKdO1E5VKZaQLNOfL3e/iCdugwNx3xFy7R7vun/Efs=";
  };

  vendorSha256 = "sha256-o/OVWALLOw7eNH3xsQlQ5ZNFV3l9iD8lhyckBt6Qn3E=";

  passthru.tests = { inherit (nixosTests.prometheus-exporters) bird; };

  meta = with lib; {
    description = "Prometheus exporter for the bird routing daemon";
    homepage = "https://github.com/czerwonk/bird_exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ lukegb ];
  };
}
