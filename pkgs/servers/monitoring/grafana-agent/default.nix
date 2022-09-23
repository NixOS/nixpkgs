{ lib, buildGoModule, fetchFromGitHub, systemd, nixosTests }:

buildGoModule rec {
  pname = "grafana-agent";
  version = "0.24.1";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "grafana";
    repo = "agent";
    sha256 = "sha256-WxULVtqKxYXMWNY4l0wvTkqcDkPrlHcS70NgQhe8nzU=";
  };

  vendorSha256 = "sha256-hdo8uiVJAMMPo1N8kLDFPSbyTr5WxNKtq8E7pj6Plak=";

  tags = [
    "nonetwork"
    "nodocker"
  ];

  # uses go-systemd, which uses libsystemd headers
  # https://github.com/coreos/go-systemd/issues/351
  NIX_CFLAGS_COMPILE = [ "-I${lib.getDev systemd}/include" ];

  # tries to access /sys: https://github.com/grafana/agent/issues/333
  preBuild = ''
    rm pkg/integrations/node_exporter/node_exporter_test.go
  '';

  # go-systemd uses libsystemd under the hood, which does dlopen(libsystemd) at
  # runtime.
  # Add to RUNPATH so it can be found.
  postFixup = ''
    patchelf \
      --set-rpath "${lib.makeLibraryPath [ (lib.getLib systemd) ]}:$(patchelf --print-rpath $out/bin/agent)" \
      $out/bin/agent
  '';

  passthru.tests.grafana-agent = nixosTests.grafana-agent;

  meta = with lib; {
    description = "A lightweight subset of Prometheus and more, optimized for Grafana Cloud";
    license = licenses.asl20;
    homepage = "https://grafana.com/products/cloud";
    maintainers = with maintainers; [ flokli ];
    platforms = platforms.linux;
  };
}
