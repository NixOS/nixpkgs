{ lib, stdenv, buildGoModule, fetchFromGitHub, systemd, nixosTests }:

buildGoModule rec {
  pname = "grafana-agent";
  version = "0.32.1";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "grafana";
    repo = "agent";
    sha256 = "sha256-t5rQSNLpX0ktK4mKgX6OhNLkANQ1LbFEjmQo/r7UHOM=";
  };

  vendorHash = "sha256-5beHG1mZkNcDhccleqTlMA+uiV5d6SSh2QWiL4g3O28=";
  proxyVendor = true; # darwin/linux hash mismatch

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
    "cmd/grafana-agent"
    "cmd/grafana-agentctl"
  ];

  # uses go-systemd, which uses libsystemd headers
  # https://github.com/coreos/go-systemd/issues/351
  env.NIX_CFLAGS_COMPILE = toString (lib.optionals stdenv.isLinux [ "-I${lib.getDev systemd}/include" ]);

  # go-systemd uses libsystemd under the hood, which does dlopen(libsystemd) at
  # runtime.
  # Add to RUNPATH so it can be found.
  postFixup = lib.optionalString stdenv.isLinux ''
    patchelf \
      --set-rpath "${lib.makeLibraryPath [ (lib.getLib systemd) ]}:$(patchelf --print-rpath $out/bin/grafana-agent)" \
      $out/bin/grafana-agent
  '';

  passthru.tests.grafana-agent = nixosTests.grafana-agent;

  meta = with lib; {
    description = "A lightweight subset of Prometheus and more, optimized for Grafana Cloud";
    license = licenses.asl20;
    homepage = "https://grafana.com/products/cloud";
    maintainers = with maintainers; [ flokli indeednotjames ];
  };
}
