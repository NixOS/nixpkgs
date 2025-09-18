{
  bash,
  bison,
  buildGoModule,
  cmake,
  cups,
  curl,
  dlib,
  fetchFromGitHub,
  fetchurl,
  flex,
  freeipmi,
  go,
  google-cloud-cpp,
  grpc,
  jemalloc,
  json_c,
  lib,
  libbacktrace,
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
  pkg-config,
  protobuf,
  replaceVars,
  snappy,
  stdenv,
  systemd,
  zlib,

  withCloudUi ? false,
  withConnPrometheus ? false,
  withConnPubSub ? false,
  withCups ? false,
  withDBengine ? true,
  withDebug ? false,
  withEbpf ? false,
  withIpmi ? stdenv.hostPlatform.isLinux,
  withLibbacktrace ? true,
  withML ? true,
  withNdsudo ? false,
  withNetfilter ? stdenv.hostPlatform.isLinux,
  withNetworkViewer ? stdenv.hostPlatform.isLinux,
  withSsl ? true,
  withSystemdJournal ? stdenv.hostPlatform.isLinux,
  withSystemdUnits ? stdenv.hostPlatform.isLinux,
}:
stdenv.mkDerivation (finalAttrs: {
  version = "2.6.3";
  pname = "netdata";

  src = fetchFromGitHub {
    owner = "netdata";
    repo = "netdata";
    rev = "v${finalAttrs.version}";
    hash = "sha256-J6QHeukhtHHLx92NGtoOmPwq6gvL9eyVYBQiDD1cEDk=";
    fetchSubmodules = true;
  };

  strictDeps = true;

  nativeBuildInputs = [
    bison
    cmake
    flex
    go
    makeWrapper
    ninja
    pkg-config
  ]
  ++ lib.optionals withCups [ cups.dev ];

  # bash is only used to rewrite shebangs
  buildInputs = [
    bash
    curl
    jemalloc
    json_c
    libuv
    libyaml
    lz4
    protobuf
    zlib
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libossp_uuid
  ]

  ++ lib.optionals (stdenv.hostPlatform.isLinux) [
    libcap
    libuuid
    lm_sensors
  ]
  ++ lib.optionals withConnPrometheus [ snappy ]
  ++ lib.optionals withConnPubSub [
    google-cloud-cpp
    grpc
  ]
  ++ lib.optionals withCups [ cups ]
  ++ lib.optionals withEbpf [
    libbpf
    libelf
  ]
  ++ lib.optionals withIpmi [ freeipmi ]
  ++ lib.optionals withLibbacktrace [ libbacktrace ]
  ++ lib.optionals withNetfilter [
    libmnl
    libnetfilter_acct
  ]
  ++ lib.optionals withSsl [ openssl ]
  ++ lib.optionals withSystemdJournal [ systemd ]
  ++ lib.optionals withSystemdUnits [ systemd ];

  patches = [
    # Allow ndsudo to use non-hardcoded `PATH`
    # See https://github.com/netdata/netdata/pull/17377#issuecomment-2183017868
    #     https://github.com/netdata/netdata/security/advisories/GHSA-pmhq-4cxq-wj93
    ./ndsudo-fix-path.patch

    ./use-local-libbacktrace.patch
  ]
  ++ lib.optional withCloudUi (
    replaceVars ./dashboard-v3-add.patch {
      # FIXME web.archive.org link can be replace once https://github.com/netdata/netdata-cloud/issues/1081 resolved
      # last update 04/01/2025 04:45:14
      dashboardTarball = fetchurl {
        url = "https://web.archive.org/web/20250401044514/https://app.netdata.cloud/agent.tar.gz";
        hash = "sha256-NtmM1I3VrvFErMoBl+w63Nt0DzOOsaB98cxE/axm8mE=";
      };
    }
  );

  # Guard against unused build-time development inputs in closure. Without
  # the ./skip-CONFIGURE_COMMAND.patch patch the closure retains inputs up
  # to bootstrap tools:
  #   https://github.com/NixOS/nixpkgs/pull/175719
  # We pick zlib.dev as a simple canary package with pkg-config input.
  disallowedReferences = lib.optional (!withDebug) zlib.dev;

  donStrip = withDebug || withLibbacktrace;
  env.NIX_CFLAGS_COMPILE = lib.optionalString withDebug "-O1 -ggdb -DNETDATA_INTERNAL_CHECKS=1";

  postInstall = ''
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
    ${lib.optionalString withIpmi ''
      mv $out/libexec/netdata/plugins.d/freeipmi.plugin \
         $out/libexec/netdata/plugins.d/freeipmi.plugin.org
    ''}
    ${lib.optionalString withNdsudo ''
      mv $out/libexec/netdata/plugins.d/ndsudo \
        $out/libexec/netdata/plugins.d/ndsudo.org

      ln -s /var/lib/netdata/ndsudo/ndsudo $out/libexec/netdata/plugins.d/ndsudo
    ''}
    ${lib.optionalString withNetworkViewer ''
      mv $out/libexec/netdata/plugins.d/network-viewer.plugin \
          $out/libexec/netdata/plugins.d/network-viewer.plugin.org
    ''}
    ${lib.optionalString withSystemdJournal ''
      mv $out/libexec/netdata/plugins.d/systemd-journal.plugin \
          $out/libexec/netdata/plugins.d/systemd-journal.plugin.org
    ''}
    ${lib.optionalString withSystemdUnits ''
      mv $out/libexec/netdata/plugins.d/systemd-units.plugin \
          $out/libexec/netdata/plugins.d/systemd-units.plugin.org
    ''}
  '';

  preConfigure = ''
    export GOCACHE=$TMPDIR/go-cache
    export GOPATH=$TMPDIR/go
    export GOSUMDB=off

    substituteInPlace packaging/cmake/Modules/NetdataGoTools.cmake \
      --replace-fail \
        'GOPROXY=https://proxy.golang.org' \
        'GOPROXY=file://${finalAttrs.passthru.netdata-go-modules},file://${finalAttrs.passthru.nd-mcp}'

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
      --replace-fail 'set(varlibdir_POST "''${NETDATA_RUNTIME_PREFIX}/var/lib/netdata")' 'set(varlibdir_POST "/var/lib/netdata")' \
      --replace-fail 'set(BUILD_INFO_CMAKE_CACHE_ARCHIVE_PATH "usr/share/netdata")' 'set(BUILD_INFO_CMAKE_CACHE_ARCHIVE_PATH "${placeholder "out"}/share/netdata")'
  '';

  cmakeFlags = [
    "-DWEB_DIR=share/netdata/web"
    (lib.cmakeBool "ENABLE_DASHBOARD" withCloudUi)
    (lib.cmakeBool "ENABLE_DBENGINE" withDBengine)
    (lib.cmakeBool "ENABLE_EXPORTER_PROMETHEUS_REMOTE_WRITE" withConnPrometheus)
    (lib.cmakeBool "ENABLE_JEMALLOC" true)
    (lib.cmakeBool "ENABLE_LIBBACKTRACE" withLibbacktrace)
    (lib.cmakeBool "ENABLE_ML" withML)
    (lib.cmakeBool "ENABLE_PLUGIN_CUPS" withCups)
    (lib.cmakeBool "ENABLE_PLUGIN_EBPF" withEbpf)
    (lib.cmakeBool "ENABLE_PLUGIN_FREEIPMI" withIpmi)
    (lib.cmakeBool "ENABLE_PLUGIN_NETWORK_VIEWER" withNetworkViewer)
    (lib.cmakeBool "ENABLE_PLUGIN_SYSTEMD_JOURNAL" withSystemdJournal)
    (lib.cmakeBool "ENABLE_PLUGIN_SYSTEMD_UNITS" withSystemdUnits)
    (lib.cmakeBool "ENABLE_PLUGIN_XENSTAT" false)
    # Suggested by upstream.
    "-G Ninja"
  ]
  ++ lib.optional withML "-DNETDATA_DLIB_SOURCE_PATH=${dlib.src}";

  postFixup = ''
    wrapProgram $out/bin/netdata-claim.sh --prefix PATH : ${lib.makeBinPath [ openssl ]}
    wrapProgram $out/libexec/netdata/plugins.d/cgroup-network-helper.sh --prefix PATH : ${lib.makeBinPath [ bash ]}
    wrapProgram $out/bin/netdatacli --set NETDATA_PIPENAME /run/netdata/ipc
    ${lib.optionalString (stdenv.hostPlatform.isLinux) ''
      substituteInPlace $out/lib/netdata/conf.d/go.d/sensors.conf --replace-fail '/usr/bin/sensors' '${lm_sensors}/bin/sensors'
    ''}

    # Time to cleanup the output directory.
    unlink $out/sbin
    cp $out/etc/netdata/edit-config $out/bin/netdata-edit-config
    mv $out/lib/netdata/conf.d $out/share/netdata/conf.d
    rm -rf $out/{var,usr,etc}
  '';

  enableParallelBuilding = true;

  passthru = rec {
    nd-mcp =
      (buildGoModule {
        pname = "nd-mcp";
        version = finalAttrs.version;
        inherit (finalAttrs) src;

        sourceRoot = "${finalAttrs.src.name}/src/web/mcp/bridges/stdio-golang";

        vendorHash = "sha256-6JfHrBloJQ5wHyogIPTVDZjlITWZXbsv2m2lMlQmBUY=";

        proxyVendor = true;
        doCheck = false;

        subPackages = [ "." ];

        ldflags = [
          "-s"
          "-w"
        ];

        meta = {
          description = "Netdata Model Context Protocol (MCP) Integration";
          license = lib.licenses.gpl3Only;
        };
      }).goModules;

    netdata-go-modules =
      (buildGoModule {
        pname = "netdata-go-plugins";
        inherit (finalAttrs) version src;

        sourceRoot = "${finalAttrs.src.name}/src/go/plugin/go.d";

        vendorHash = "sha256-aOFmfBcBjnTfFHfMNemSJHbnMnhBojYrGe21zDxPxME=";
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
    inherit
      withIpmi
      withNdsudo
      withNetworkViewer
      withSystemdJournal
      ;
    tests.netdata = nixosTests.netdata;
  };

  meta = with lib; {
    broken = stdenv.buildPlatform != stdenv.hostPlatform || withEbpf;
    description = "Real-time performance monitoring tool";
    homepage = "https://www.netdata.cloud/";
    changelog = "https://github.com/netdata/netdata/releases/tag/v${version}";
    license = [ licenses.gpl3Plus ] ++ lib.optionals (withCloudUi) [ licenses.ncul1 ];
    mainProgram = "netdata";
    platforms = platforms.unix;
    maintainers = with maintainers; [
      mkg20001
      rhoriguchi
    ];
  };
})
