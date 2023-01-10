{ lib, buildGoModule, fetchFromGitHub, systemd, nixosTests }:

buildGoModule rec {
  pname = "grafana-agent";
  version = "0.30.1";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "grafana";
    repo = "agent";
    sha256 = "sha256-QunB14B3HRzB5UL5OZaFsm4WGIOMnByYKblTogVOeHE=";
  };

  vendorSha256 = "sha256-Cl3oygH1RPF+ZdJvkDmr7eyU5daxaZwNE8pQOHK/qP4=";

  ldflags = let
    prefix = "github.com/grafana/agent/pkg/build";
  in [
    "-s" "-w"
    # https://github.com/grafana/agent/blob/d672eba4ca8cb010ad8a9caef4f8b66ea6ee3ef2/Makefile#L125
    "-X ${prefix}.Version=${version}"
    "-X ${prefix}.Branch=v${version}"
    "-X ${prefix}.Revision=v${version}"
    "-X ${prefix}.BuildUser=nix"
    "-X ${prefix}.BuildDate=1980-01-01T00:00:00Z"
  ];

  tags = [
    "nonetwork"
    "nodocker"
    "promtail_journal_enabled"
  ];

  subPackages = [
    "cmd/agent"
    "cmd/agentctl"
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
