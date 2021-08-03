{ lib, buildGoModule, fetchFromGitHub, systemd }:

buildGoModule rec {
  pname = "grafana-agent";
  version = "0.18.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "grafana";
    repo = "agent";
    sha256 = "sha256-FUAaM4jYjyYeu5TX5I8icuzjGv80ZzZPWSsNwE5w84U=";
  };

  vendorSha256 = "sha256-xQNsRL0hFuJ/gm1K/1IpzAGIqpyN2CF1EeX/cEfcBBM=";

  patches = [
    # https://github.com/grafana/agent/issues/731
    ./skip_test_requiring_network.patch
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

  meta = with lib; {
    description = "A lightweight subset of Prometheus and more, optimized for Grafana Cloud";
    license = licenses.asl20;
    homepage = "https://grafana.com/products/cloud";
    maintainers = with maintainers; [ flokli ];
    platforms = platforms.linux;
  };
}
