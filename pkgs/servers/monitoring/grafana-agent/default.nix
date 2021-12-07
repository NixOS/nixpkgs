{ lib, buildGoModule, fetchFromGitHub, systemd }:

buildGoModule rec {
  pname = "grafana-agent";
  version = "0.21.1";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "grafana";
    repo = "agent";
    sha256 = "sha256-ABiyL1QpVtoQ4hwpDc3rwlhwILdQBX1wHKHj1K5O2jw=";
  };

  vendorSha256 = "sha256-VFCuCUV5tq1svQN8WoFdmxhLI8OEODQd2kc1caYLGro=";

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
