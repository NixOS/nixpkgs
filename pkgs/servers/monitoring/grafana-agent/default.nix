{ lib
, buildGoModule
, fetchFromGitHub
, fetchYarnDeps
, fixup-yarn-lock
, grafana-agent
, nix-update-script
, nixosTests
, nodejs
, stdenv
, systemd
, testers
, yarn
}:

buildGoModule rec {
  pname = "grafana-agent";
  version = "0.41.1";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "agent";
    rev = "v${version}";
    hash = "sha256-A/h8Mwtor4VUT7e7TsNiE/0OOXCSq38GAf9j7c8ZDKk=";
  };

  vendorHash = "sha256-W29GZoZfgjdSwGiFz4udGA9gXgmM0xIDEGld7ZE1ycQ=";
  proxyVendor = true; # darwin/linux hash mismatch

  frontendYarnOfflineCache = fetchYarnDeps {
    yarnLock = src + "/internal/web/ui/yarn.lock";
    hash = "sha256-WqbIg18qUNcs9O2wh7DAzwXKb60iEuPL8zFCIgScqI0=";
  };

  ldflags = let
    prefix = "github.com/grafana/agent/internal/build";
  in [
    "-s" "-w"
    # https://github.com/grafana/agent/blob/v0.41.0/Makefile#L132-L137
    "-X ${prefix}.Version=${version}"
    "-X ${prefix}.Branch=v${version}"
    "-X ${prefix}.Revision=v${version}"
    "-X ${prefix}.BuildUser=nix"
    "-X ${prefix}.BuildDate=1980-01-01T00:00:00Z"
  ];

  nativeBuildInputs = [ fixup-yarn-lock nodejs yarn ];

  tags = [
    "builtinassets"
    "nonetwork"
    "nodocker"
    "promtail_journal_enabled"
  ];

  subPackages = [
    "cmd/grafana-agent"
    "cmd/grafana-agentctl"
    "internal/web/ui"
  ];

  preBuild = ''
    export HOME="$TMPDIR"

    pushd internal/web/ui
    fixup-yarn-lock yarn.lock
    yarn config --offline set yarn-offline-mirror $frontendYarnOfflineCache
    yarn install --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive
    patchShebangs node_modules
    yarn --offline run build
    popd
  '';

  # do not pass preBuild to go-modules.drv, as it would otherwise fail to build.
  # but even if it would work, it simply isn't needed in that scope.
  overrideModAttrs = (_: {
    preBuild = null;
  });

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

  passthru = {
    tests = {
      inherit (nixosTests) grafana-agent;
      version = testers.testVersion {
        inherit version;
        command = "${lib.getExe grafana-agent} --version";
        package = grafana-agent;
      };
    };
    updateScript = nix-update-script { };
    # alias for nix-update to be able to find and update this attribute
    offlineCache = frontendYarnOfflineCache;
  };

  meta = {
    description = "A lightweight subset of Prometheus and more, optimized for Grafana Cloud";
    license = lib.licenses.asl20;
    homepage = "https://grafana.com/products/cloud";
    changelog = "https://github.com/grafana/agent/blob/${src.rev}/CHANGELOG.md";
    maintainers = with lib.maintainers; [ flokli emilylange ];
    mainProgram = "grafana-agent";
  };
}
