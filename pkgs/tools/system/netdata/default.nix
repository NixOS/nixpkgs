{ lib, stdenv, fetchFromGitHub, fetchpatch, cmake, pkg-config, makeWrapper
, CoreFoundation, IOKit, libossp_uuid
, nixosTests
, bash, curl, jemalloc, json_c, libuv, zlib, libyaml, libelf, libbpf
, libcap, libuuid, lm_sensors, protobuf
, go, buildGoModule, ninja
, withCups ? false, cups
, withDBengine ? true, lz4
, withIpmi ? (!stdenv.isDarwin), freeipmi
, withNetfilter ? (!stdenv.isDarwin), libmnl, libnetfilter_acct
, withCloud ? false
, withCloudUi ? false
, withConnPubSub ? false, google-cloud-cpp, grpc
, withConnPrometheus ? false, snappy
, withSsl ? true, openssl
, withSystemdJournal ? (!stdenv.isDarwin), systemd
, withDebug ? false
, withEbpf ? false
, withNetworkViewer ? (!stdenv.isDarwin)
}:

stdenv.mkDerivation rec {
  # Don't forget to update go.d.plugin.nix as well
  version = "1.45.0";
  pname = "netdata";

  src = fetchFromGitHub {
    owner = "netdata";
    repo = "netdata";
    rev = "v${version}";
    hash = if withCloudUi
      then "sha256-AyhS5vwGZLnc+xmf9Qvk2v8rTzhHSUe7LpAbwRYjrKM="
      else "sha256-11UHXPnXC4pzK/oXOZJ7f9X86EV9uHOvMtOCnxTV86U=";
    fetchSubmodules = true;

    # Remove v2 dashboard distributed under NCUL1. Make sure an empty
    # Makefile.am exists, as autoreconf will get confused otherwise.
    postFetch = lib.optionalString (!withCloudUi) ''
      rm -rf $out/src/web/gui/v2/*
      touch $out/src/web/gui/v2/Makefile.am
    '';
  };

  strictDeps = true;

  nativeBuildInputs = [ cmake pkg-config makeWrapper go ninja ];
  # bash is only used to rewrite shebangs
  buildInputs = [ bash curl jemalloc json_c libuv zlib libyaml ]
    ++ lib.optionals stdenv.isDarwin [ CoreFoundation IOKit libossp_uuid ]
    ++ lib.optionals (!stdenv.isDarwin) [ libcap libuuid ]
    ++ lib.optionals withCups [ cups ]
    ++ lib.optionals withDBengine [ lz4 ]
    ++ lib.optionals withIpmi [ freeipmi ]
    ++ lib.optionals withNetfilter [ libmnl libnetfilter_acct ]
    ++ lib.optionals withConnPubSub [ google-cloud-cpp grpc ]
    ++ lib.optionals withConnPrometheus [ snappy ]
    ++ lib.optionals withEbpf [ libelf libbpf ]
    ++ lib.optionals (withCloud || withConnPrometheus) [ protobuf ]
    ++ lib.optionals withSystemdJournal [ systemd ]
    ++ lib.optionals withSsl [ openssl ];

  patches = [
    # required to prevent plugins from relying on /etc
    # and /var
    # ./no-files-in-etc-and-var.patch

    # Avoid build-only inputs in closure leaked by configure command:
    #   https://github.com/NixOS/nixpkgs/issues/175693#issuecomment-1143344162
    # ./skip-CONFIGURE_COMMAND.patch

    # Allow building without non-free v2 dashboard.
    (fetchpatch {
      url = "https://github.com/netdata/netdata/pull/17240.patch";
      hash = "sha256-tgsnbNY0pxFU3bz1J1qPaAeVsozsk2bpHV2mNy8A9is=";
    })
  ];

  # Guard against unused buld-time development inputs in closure. Without
  # the ./skip-CONFIGURE_COMMAND.patch patch the closure retains inputs up
  # to bootstrap tools:
  #   https://github.com/NixOS/nixpkgs/pull/175719
  # We pick zlib.dev as a simple canary package with pkg-config input.
  disallowedReferences = lib.optional (!withDebug) zlib.dev;

  donStrip = withDebug;
  env.NIX_CFLAGS_COMPILE = lib.optionalString withDebug "-O1 -ggdb -DNETDATA_INTERNAL_CHECKS=1";

  postInstall = ''
    # Relocate one folder above.
    mv $out/usr/* $out/
  '' + lib.optionalString (!stdenv.isDarwin) ''
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
    mv $out/libexec/netdata/plugins.d/logs-management.plugin \
       $out/libexec/netdata/plugins.d/logs-management.plugin.org
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
  '';

  preConfigure = lib.optionalString (!stdenv.isDarwin) ''
    substituteInPlace src/collectors/python.d.plugin/python_modules/third_party/lm_sensors.py \
      --replace 'ctypes.util.find_library("sensors")' '"${lm_sensors.out}/lib/libsensors${stdenv.hostPlatform.extensions.sharedLibrary}"'
  '' + ''
    export GOCACHE=$TMPDIR/go-cache
    export GOPATH=$TMPDIR/go
    export GOPROXY=file://${passthru.netdata-go-modules}
    export GOSUMDB=off

    # Prevent the path to be caught into the Nix store path.
    substituteInPlace CMakeLists.txt \
      --replace 'set(CACHE_DIR "''${CMAKE_INSTALL_PREFIX}/var/cache/netdata")' 'set(CACHE_DIR "/var/cache/netdata")'

    substituteInPlace CMakeLists.txt \
      --replace 'set(CONFIG_DIR "''${CMAKE_INSTALL_PREFIX}/etc/netdata")' 'set(CONFIG_DIR "/etc/netdata")'

    substituteInPlace CMakeLists.txt \
      --replace 'set(LIBCONFIG_DIR "''${CMAKE_INSTALL_PREFIX}/usr/lib/netdata/conf.d")' 'set(LIBCONFIG_DIR "${placeholder "out"}/share/netdata/conf.d")'

    substituteInPlace CMakeLists.txt \
      --replace 'set(LOG_DIR "''${CMAKE_INSTALL_PREFIX}/var/log/netdata")' 'set(LOG_DIR "/var/log/netdata")'

    substituteInPlace CMakeLists.txt \
      --replace 'set(PLUGINS_DIR "''${CMAKE_INSTALL_PREFIX}/usr/libexec/netdata/plugins.d")' 'set(PLUGINS_DIR "${placeholder "out"}/libexec/netdata/plugins.d")'

    substituteInPlace CMakeLists.txt \
      --replace 'set(VARLIB_DIR "''${CMAKE_INSTALL_PREFIX}/var/lib/netdata")' 'set(VARLIB_DIR "/var/lib/netdata")'

    substituteInPlace CMakeLists.txt \
      --replace 'set(pkglibexecdir_POST "''${CMAKE_INSTALL_PREFIX}/usr/libexec/netdata")' 'set(pkglibexecdir_POST "${placeholder "out"}/libexec/netdata")'

    substituteInPlace CMakeLists.txt \
      --replace 'set(localstatedir_POST "''${CMAKE_INSTALL_PREFIX}/var")' 'set(localstatedir_POST "/var")'

    substituteInPlace CMakeLists.txt \
      --replace 'set(sbindir_POST "''${CMAKE_INSTALL_PREFIX}/usr/sbin")' 'set(sbindir_POST "${placeholder "out"}/bin")'

    substituteInPlace CMakeLists.txt \
      --replace 'set(configdir_POST "''${CMAKE_INSTALL_PREFIX}/etc/netdata")' 'set(configdir_POST "/etc/netdata")'

    substituteInPlace CMakeLists.txt \
      --replace 'set(libconfigdir_POST "''${CMAKE_INSTALL_PREFIX}/usr/lib/netdata/conf.d")' 'set(libconfigdir_POST "${placeholder "out"}/share/netdata/conf.d")'

    substituteInPlace CMakeLists.txt \
      --replace 'set(cachedir_POST "''${CMAKE_INSTALL_PREFIX}/var/cache/netdata")' 'set(libconfigdir_POST "/var/cache/netdata")'

    substituteInPlace CMakeLists.txt \
      --replace 'set(registrydir_POST "''${CMAKE_INSTALL_PREFIX}/var/lib/netdata/registry")' 'set(registrydir_POST "/var/lib/netdata/registry")'

    substituteInPlace CMakeLists.txt \
      --replace 'set(varlibdir_POST "''${CMAKE_INSTALL_PREFIX}/var/lib/netdata")' 'set(varlibdir_POST "/var/lib/netdata")'
  '';

  cmakeFlags = [
    "-DWEB_DIR=share/netdata/web"
    (lib.cmakeBool "ENABLE_CLOUD" withCloud)
    # ACLK is agent cloud link.
    (lib.cmakeBool "ENABLE_ACLK" withCloud)
    (lib.cmakeBool "ENABLE_DASHBOARD_V2" withCloudUi)
    (lib.cmakeBool "ENABLE_DBENGINE" withDBengine)
    (lib.cmakeBool "ENABLE_PLUGIN_SYSTEMD_JOURNAL" withSystemdJournal)
    (lib.cmakeBool "ENABLE_PLUGIN_NETWORK_VIEWER" withNetworkViewer)
    (lib.cmakeBool "ENABLE_PLUGIN_EBPF" withEbpf)
    # raitobezarius: I do not wish to maintain Xen-related things alone, thus, disabled.
    # Feel free to open an issue / PR to fix this.
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

  enableParallelBuild = true;

  passthru = rec {
    netdata-go-modules = (buildGoModule {
      pname = "netdata-go-plugins";
      inherit version src;

      sourceRoot = "${src.name}/src/go/collectors/go.d.plugin";

      vendorHash = "sha256-KO+xMk6fpZCYRyxxKrsGfOHJ2bwjBaSmkgz1jIUHaZs=";
      doCheck = false;
      proxyVendor = true;

      ldflags = [ "-s" "-w" "-X main.version=${version}" ];

      passthru.tests = tests;
      meta = meta // {
        description = "Netdata orchestrator for data collection modules written in Go";
        mainProgram = "godplugin";
        license = lib.licenses.gpl3Only;
      };
    }).goModules;
    inherit withIpmi withNetworkViewer;
    tests.netdata = nixosTests.netdata;
  };

  meta = with lib; {
    broken = stdenv.isDarwin || stdenv.buildPlatform != stdenv.hostPlatform || withEbpf;
    description = "Real-time performance monitoring tool";
    homepage = "https://www.netdata.cloud/";
    changelog = "https://github.com/netdata/netdata/releases/tag/v${version}";
    license = [ licenses.gpl3Plus ]
      ++ lib.optionals (withCloudUi) [ licenses.ncul1 ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ raitobezarius ];
  };
}
