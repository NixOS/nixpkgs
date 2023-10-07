{ lib, stdenv, fetchFromGitHub, fetchpatch, autoreconfHook, pkg-config, makeWrapper
, CoreFoundation, IOKit, libossp_uuid
, nixosTests
, netdata-go-plugins
, bash, curl, jemalloc, libuv, zlib, libyaml
, libcap, libuuid, lm_sensors, protobuf
, withCups ? false, cups
, withDBengine ? true, lz4
, withIpmi ? (!stdenv.isDarwin), freeipmi
, withNetfilter ? (!stdenv.isDarwin), libmnl, libnetfilter_acct
, withCloud ? (!stdenv.isDarwin), json_c
, withCloudUi ? false
, withConnPubSub ? false, google-cloud-cpp, grpc
, withConnPrometheus ? false, snappy
, withSsl ? true, openssl
, withDebug ? false
}:

stdenv.mkDerivation rec {
  # Don't forget to update go.d.plugin.nix as well
  version = "1.42.4";
  pname = "netdata";

  src = fetchFromGitHub {
    owner = "netdata";
    repo = "netdata";
    rev = "v${version}";
    hash = if withCloudUi
      then "sha256-MaU9sOQD+Y03M+yoSWt1GuV+DrBlD7+r/Qm2JJ9s8EU="
      else "sha256-41QntBt0MoO1hAsDb8LhHgvvNMzt9R1ZdgiPaR7NrPU=";
    fetchSubmodules = true;

    # Remove v2 dashboard distributed under NCUL1. Make sure an empty
    # Makefile.am exists, as autoreconf will get confused otherwise.
    postFetch = lib.optionalString (!withCloudUi) ''
      rm -rf $out/web/gui/v2/*
      touch $out/web/gui/v2/Makefile.am
    '';
  };

  strictDeps = true;

  nativeBuildInputs = [ autoreconfHook pkg-config makeWrapper protobuf ];
  # bash is only used to rewrite shebangs
  buildInputs = [ bash curl jemalloc libuv zlib libyaml ]
    ++ lib.optionals stdenv.isDarwin [ CoreFoundation IOKit libossp_uuid ]
    ++ lib.optionals (!stdenv.isDarwin) [ libcap libuuid ]
    ++ lib.optionals withCups [ cups ]
    ++ lib.optionals withDBengine [ lz4 ]
    ++ lib.optionals withIpmi [ freeipmi ]
    ++ lib.optionals withNetfilter [ libmnl libnetfilter_acct ]
    ++ lib.optionals withCloud [ json_c ]
    ++ lib.optionals withConnPubSub [ google-cloud-cpp grpc ]
    ++ lib.optionals withConnPrometheus [ snappy ]
    ++ lib.optionals (withCloud || withConnPrometheus) [ protobuf ]
    ++ lib.optionals withSsl [ openssl ];

  patches = [
    # required to prevent plugins from relying on /etc
    # and /var
    ./no-files-in-etc-and-var.patch

    # Avoid build-only inputs in closure leaked by configure command:
    #   https://github.com/NixOS/nixpkgs/issues/175693#issuecomment-1143344162
    ./skip-CONFIGURE_COMMAND.patch

    # Allow building without non-free v2 dashboard.
    (fetchpatch {
      url = "https://github.com/peat-psuwit/netdata/commit/6ccbdd1500db2b205923968688d5f1777430a326.patch";
      hash = "sha256-jAyk5HlxdjFn5IP6jOKP8/SXOraMQSA6r1krThe+s7g=";
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
    ln -s ${netdata-go-plugins}/lib/netdata/conf.d/* $out/lib/netdata/conf.d
    ln -s ${netdata-go-plugins}/bin/godplugin $out/libexec/netdata/plugins.d/go.d.plugin
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
    ${lib.optionalString withIpmi ''
      mv $out/libexec/netdata/plugins.d/freeipmi.plugin \
         $out/libexec/netdata/plugins.d/freeipmi.plugin.org
    ''}
  '';

  preConfigure = lib.optionalString (!stdenv.isDarwin) ''
    substituteInPlace collectors/python.d.plugin/python_modules/third_party/lm_sensors.py \
      --replace 'ctypes.util.find_library("sensors")' '"${lm_sensors.out}/lib/libsensors${stdenv.hostPlatform.extensions.sharedLibrary}"'
  '';

  configureFlags = [
    "--localstatedir=/var"
    "--sysconfdir=/etc"
    "--disable-ebpf"
    "--with-jemalloc=${jemalloc}"
  ] ++ lib.optionals (!withDBengine) [
    "--disable-dbengine"
  ] ++ lib.optionals (!withCloud) [
    "--disable-cloud"
  ] ++ lib.optionals (!withCloudUi) [
    "--disable-cloud-ui"
  ];

  postFixup = ''
    wrapProgram $out/bin/netdata-claim.sh --prefix PATH : ${lib.makeBinPath [ openssl ]}
    wrapProgram $out/libexec/netdata/plugins.d/cgroup-network-helper.sh --prefix PATH : ${lib.makeBinPath [ bash ]}
    wrapProgram $out/bin/netdatacli --set NETDATA_PIPENAME /run/netdata/ipc
  '';

  enableParallelBuild = true;

  passthru = {
    inherit withIpmi;
    tests.netdata = nixosTests.netdata;
  };

  meta = with lib; {
    broken = stdenv.isDarwin || stdenv.buildPlatform != stdenv.hostPlatform;
    description = "Real-time performance monitoring tool";
    homepage = "https://www.netdata.cloud/";
    changelog = "https://github.com/netdata/netdata/releases/tag/v${version}";
    license = [ licenses.gpl3Plus ]
      ++ lib.optionals (withCloudUi) [ licenses.ncul1 ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ raitobezarius ];
  };
}
