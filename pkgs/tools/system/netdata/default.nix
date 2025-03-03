{
  lib,
  stdenv,
  fetchFromGitHub,
  bash,
  buildGoModule,
  cmake,
  cups,
  curl,
  darwin,
  freeipmi,
  go,
  google-cloud-cpp,
  grpc,
  jemalloc,
  json_c,
  libbpf,
  libcap,
  libelf,
  libmnl,
  libnetfilter_acct,
  libossp_uuid,
  libuuid,
  libuv,
  libyaml,
  lm_sensors,
  lz4,
  makeWrapper,
  ninja,
  nixosTests,
  openssl,
  overrideSDK,
  pkg-config,
  protobuf,
  snappy,
  systemd,
  withCloud ? false,
  withCloudUi ? false,
  withConnPrometheus ? false,
  withConnPubSub ? false,
  withCups ? false,
  withDBengine ? true,
  withDebug ? false,
  withEbpf ? false,
  withIpmi ? (stdenv.hostPlatform.isLinux),
  withNetfilter ? (stdenv.hostPlatform.isLinux),
  withNetworkViewer ? (stdenv.hostPlatform.isLinux),
  withSsl ? true,
  withSystemdJournal ? (stdenv.hostPlatform.isLinux),
  zlib,
}:
let
  stdenv' = if stdenv.hostPlatform.isDarwin then overrideSDK stdenv "11.0" else stdenv;
in
stdenv'.mkDerivation (finalAttrs: {
  version = "1.47.5";
  pname = "netdata";

  src = fetchFromGitHub {
    owner = "netdata";
    repo = "netdata";
    rev = "v${finalAttrs.version}";
    hash =
      if withCloudUi then
        "sha256-+cPYwjxg/+A5bNa517zg9xKEjUa8uPM9WD67tToPH5o="
      # we delete the v2 GUI after fetching
      else
        "sha256-0aiBUkDymmdIT/u1y2PG30QYAvb8Zc4i8ZgjOtlzt+A=";
    fetchSubmodules = true;

    # Remove v2 dashboard distributed under NCUL1. Make sure an empty
    # Makefile.am exists, as autoreconf will get confused otherwise.
    postFetch = lib.optionalString (!withCloudUi) ''
      rm -rf $out/src/web/gui/v2/*
      touch $out/src/web/gui/v2/Makefile.am
    '';
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    makeWrapper
    go
    ninja
  ] ++ lib.optionals withCups [ cups.dev ];
  # bash is only used to rewrite shebangs
  buildInputs =
    [
      bash
      curl
      jemalloc
      json_c
      libuv
      zlib
      libyaml
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin (
      with darwin.apple_sdk.frameworks;
      [
        CoreFoundation
        IOKit
        libossp_uuid
      ]
    )
    ++ lib.optionals (stdenv.hostPlatform.isLinux) [
      libcap
      libuuid
      lm_sensors
    ]
    ++ lib.optionals withCups [ cups ]
    ++ lib.optionals withDBengine [ lz4 ]
    ++ lib.optionals withIpmi [ freeipmi ]
    ++ lib.optionals withNetfilter [
      libmnl
      libnetfilter_acct
    ]
    ++ lib.optionals withConnPubSub [
      google-cloud-cpp
      grpc
    ]
    ++ lib.optionals withConnPrometheus [ snappy ]
    ++ lib.optionals withEbpf [
      libelf
      libbpf
    ]
    ++ lib.optionals (withCloud || withConnPrometheus) [ protobuf ]
    ++ lib.optionals withSystemdJournal [ systemd ]
    ++ lib.optionals withSsl [ openssl ];

  patches = [
    # Allow ndsudo to use non-hardcoded `PATH`
    # See https://github.com/netdata/netdata/pull/17377#issuecomment-2183017868
    #     https://github.com/netdata/netdata/security/advisories/GHSA-pmhq-4cxq-wj93
    ./ndsudo-fix-path.patch
    # Allow building without non-free v2 dashboard.
    ./dashboard-v2-removal.patch
  ];

  # Guard against unused build-time development inputs in closure. Without
  # the ./skip-CONFIGURE_COMMAND.patch patch the closure retains inputs up
  # to bootstrap tools:
  #   https://github.com/NixOS/nixpkgs/pull/175719
  # We pick zlib.dev as a simple canary package with pkg-config input.
  disallowedReferences = lib.optional (!withDebug) zlib.dev;

  donStrip = withDebug;
  env.NIX_CFLAGS_COMPILE = lib.optionalString withDebug "-O1 -ggdb -DNETDATA_INTERNAL_CHECKS=1";

  postInstall =
    ''
      # Relocate one folder above.
      mv $out/usr/* $out/
    ''
    + lib.optionalString (stdenv.hostPlatform.isLinux) ''
      # rename this plugin so netdata will look for setuid wrapper
      mv $out/libexec/netdata/plugins.d/apps.plugin \
         $out/libexec/netdata/plugins.d/apps.plugin.org
      mv $out/libexec/netdata/plugins.d/cgroup-network \
         $out/libexec/netdata/plugins.d/cgroup-network.org
      mv $out/libexec/netdata/plugins.d/perf.plugin \
         $out/libexec/netdata/plugins.d/perf.plugin.org
      mv $out/libexec/netdata/plugins.d/slabinfo.plugin \
         $out/libexec/netdata/plugins.d/slabinfo.plugin.org
      mv $out/libexec/netdata/plugins.d/debugfs.plugin \
         $out/libexec/netdata/plugins.d/debugfs.plugin.org
      ${lib.optionalString withSystemdJournal ''
        mv $out/libexec/netdata/plugins.d/systemd-journal.plugin \
           $out/libexec/netdata/plugins.d/systemd-journal.plugin.org
      ''}
      ${lib.optionalString withIpmi ''
        mv $out/libexec/netdata/plugins.d/freeipmi.plugin \
           $out/libexec/netdata/plugins.d/freeipmi.plugin.org
      ''}
      ${lib.optionalString withNetworkViewer ''
        mv $out/libexec/netdata/plugins.d/network-viewer.plugin \
           $out/libexec/netdata/plugins.d/network-viewer.plugin.org
      ''}
      ${lib.optionalString (!withCloudUi) ''
        rm -rf $out/share/netdata/web/index.html
        cp $out/share/netdata/web/v1/index.html $out/share/netdata/web/index.html
      ''}
    '';

  preConfigure = ''
    export GOCACHE=$TMPDIR/go-cache
    export GOPATH=$TMPDIR/go
    export GOSUMDB=off

    substituteInPlace packaging/cmake/Modules/NetdataGoTools.cmake \
      --replace-fail \
        'GOPROXY=https://proxy.golang.org' \
        'GOPROXY=file://${finalAttrs.passthru.netdata-go-modules}'

    # Prevent the path to be caught into the Nix store path.
    substituteInPlace CMakeLists.txt \
      --replace-fail 'set(CACHE_DIR "''${NETDATA_RUNTIME_PREFIX}/var/cache/netdata")' 'set(CACHE_DIR "/var/cache/netdata")' \
      --replace-fail 'set(CONFIG_DIR "''${NETDATA_RUNTIME_PREFIX}/etc/netdata")' 'set(CONFIG_DIR "/etc/netdata")' \
      --replace-fail 'set(LIBCONFIG_DIR "''${NETDATA_RUNTIME_PREFIX}/usr/lib/netdata/conf.d")' 'set(LIBCONFIG_DIR "${placeholder "out"}/share/netdata/conf.d")' \
      --replace-fail 'set(LOG_DIR "''${NETDATA_RUNTIME_PREFIX}/var/log/netdata")' 'set(LOG_DIR "/var/log/netdata")' \
      --replace-fail 'set(PLUGINS_DIR "''${NETDATA_RUNTIME_PREFIX}/usr/libexec/netdata/plugins.d")' 'set(PLUGINS_DIR "${placeholder "out"}/libexec/netdata/plugins.d")' \
      --replace-fail 'set(VARLIB_DIR "''${NETDATA_RUNTIME_PREFIX}/var/lib/netdata")' 'set(VARLIB_DIR "/var/lib/netdata")' \
      --replace-fail 'set(pkglibexecdir_POST "''${NETDATA_RUNTIME_PREFIX}/usr/libexec/netdata")' 'set(pkglibexecdir_POST "${placeholder "out"}/libexec/netdata")' \
      --replace-fail 'set(localstatedir_POST "''${NETDATA_RUNTIME_PREFIX}/var")' 'set(localstatedir_POST "/var")' \
      --replace-fail 'set(sbindir_POST "''${NETDATA_RUNTIME_PREFIX}/''${BINDIR}")' 'set(sbindir_POST "${placeholder "out"}/bin")' \
      --replace-fail 'set(configdir_POST "''${NETDATA_RUNTIME_PREFIX}/etc/netdata")' 'set(configdir_POST "/etc/netdata")' \
      --replace-fail 'set(libconfigdir_POST "''${NETDATA_RUNTIME_PREFIX}/usr/lib/netdata/conf.d")' 'set(libconfigdir_POST "${placeholder "out"}/share/netdata/conf.d")' \
      --replace-fail 'set(cachedir_POST "''${NETDATA_RUNTIME_PREFIX}/var/cache/netdata")' 'set(libconfigdir_POST "/var/cache/netdata")' \
      --replace-fail 'set(registrydir_POST "''${NETDATA_RUNTIME_PREFIX}/var/lib/netdata/registry")' 'set(registrydir_POST "/var/lib/netdata/registry")' \
      --replace-fail 'set(varlibdir_POST "''${NETDATA_RUNTIME_PREFIX}/var/lib/netdata")' 'set(varlibdir_POST "/var/lib/netdata")'
  '';

  cmakeFlags = [
    "-DWEB_DIR=share/netdata/web"
    (lib.cmakeBool "ENABLE_CLOUD" withCloud)
    # ACLK is agent cloud link.
    (lib.cmakeBool "ENABLE_ACLK" withCloud)
    (lib.cmakeBool "ENABLE_DASHBOARD_V2" withCloudUi)
    (lib.cmakeBool "ENABLE_DBENGINE" withDBengine)
    (lib.cmakeBool "ENABLE_PLUGIN_FREEIPMI" withIpmi)
    (lib.cmakeBool "ENABLE_PLUGIN_SYSTEMD_JOURNAL" withSystemdJournal)
    (lib.cmakeBool "ENABLE_PLUGIN_NETWORK_VIEWER" withNetworkViewer)
    (lib.cmakeBool "ENABLE_PLUGIN_EBPF" withEbpf)
    (lib.cmakeBool "ENABLE_PLUGIN_XENSTAT" false)
    (lib.cmakeBool "ENABLE_PLUGIN_CUPS" withCups)
    (lib.cmakeBool "ENABLE_EXPORTER_PROMETHEUS_REMOTE_WRITE" withConnPrometheus)
    (lib.cmakeBool "ENABLE_JEMALLOC" true)
    # Suggested by upstream.
    "-G Ninja"
  ];

  postFixup = ''
    wrapProgram $out/bin/netdata-claim.sh --prefix PATH : ${lib.makeBinPath [ openssl ]}
    wrapProgram $out/libexec/netdata/plugins.d/cgroup-network-helper.sh --prefix PATH : ${lib.makeBinPath [ bash ]}
    wrapProgram $out/bin/netdatacli --set NETDATA_PIPENAME /run/netdata/ipc

    # Time to cleanup the output directory.
    unlink $out/sbin
    cp $out/etc/netdata/edit-config $out/bin/netdata-edit-config
    mv $out/lib/netdata/conf.d $out/share/netdata/conf.d
    rm -rf $out/{var,usr,etc}
  '';

  enableParallelBuilding = true;

  passthru = rec {
    netdata-go-modules =
      (buildGoModule {
        pname = "netdata-go-plugins";
        inherit (finalAttrs) version src;

        sourceRoot = "${finalAttrs.src.name}/src/go/plugin/go.d";

        vendorHash = "sha256-NZ1tg+lvXNgypqmjjb5f7dHH6DIA9VOa4PMM4eq11n0=";
        doCheck = false;
        proxyVendor = true;

        ldflags = [
          "-s"
          "-w"
          "-X main.version=${finalAttrs.version}"
        ];

        passthru.tests = tests;
        meta = finalAttrs.meta // {
          description = "Netdata orchestrator for data collection modules written in Go";
          mainProgram = "godplugin";
          license = lib.licenses.gpl3Only;
        };
      }).goModules;
    inherit withIpmi withNetworkViewer;
    tests.netdata = nixosTests.netdata;
  };

  meta = with lib; {
    broken = stdenv.buildPlatform != stdenv.hostPlatform || withEbpf;
    description = "Real-time performance monitoring tool";
    homepage = "https://www.netdata.cloud/";
    changelog = "https://github.com/netdata/netdata/releases/tag/v${version}";
    license = [ licenses.gpl3Plus ] ++ lib.optionals (withCloudUi) [ licenses.ncul1 ];
    platforms = platforms.unix;
    maintainers = [ ];
  };
})
