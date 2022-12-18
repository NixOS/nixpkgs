{ lib, buildGoModule, fetchFromGitHub, nixosTests, fetchpatch
}:
buildGoModule rec {
  pname = "prometheus-aggregate-exporter";
  version = "3.0.0";

  patches = [(fetchpatch {
    url = "https://github.com/kampka/prometheus-aggregate-exporter/commit/723520f41773fff9ff1c0d0db71c0f3aa4ce55d1.patch";
    sha256 = "sha256-j2niNPsL9y7g0bZ/LRSNSU2neKrTzcUcsuwiR+xQ7sI=";
  })];

  src = fetchFromGitHub {
    owner = "warmans";
    repo = "prometheus-aggregate-exporter";
    rev = "v${version}";
    sha256 = "sha256-514Ti07HQLBife2lqGmISsAgN+EJLF8KLL7rwBG6Amo=";
  };

  vendorSha256 = "sha256-EejTaOq/25q5cA10IiWFOhB0GplnS4oiKSjt7DJAo/I=";

  postBuild = ''
    mv $GOPATH/bin/cmd $GOPATH/bin/aggregate_exporter
    rm $GOPATH/bin/fixture
  '';
  ldflags = [
    "-X main.Version=${version}"
  ];
  doCheck = false;

  passthru.tests = { inherit (nixosTests.prometheus-exporters) aggregate; };

  meta = with lib; {
    description = "Aggregate prometheus exporters into a single endpoint";
    homepage = "https://github.com/warmans/prometheus-aggregate-exporter";
    changelog = "https://github.com/warmans/prometheus-aggregate-exporter/releases";
    license = licenses.mit;
  };
}
