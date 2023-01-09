{ lib, stdenv, callPackage, fetchFromGitHub, autoreconfHook, pkg-config, makeWrapper
, CoreFoundation, IOKit, libossp_uuid
, nixosTests
, curl, jemalloc, libuv, zlib
, libcap, libuuid, lm_sensors, protobuf
, withCups ? false, cups
, withDBengine ? true, judy, lz4
, withIpmi ? (!stdenv.isDarwin), freeipmi
, withNetfilter ? (!stdenv.isDarwin), libmnl, libnetfilter_acct
, withCloud ? (!stdenv.isDarwin), json_c
, withConnPubSub ? false, google-cloud-cpp, grpc
, withConnPrometheus ? false, snappy
, withSsl ? true, openssl
, withDebug ? false
}:

with lib;

let
  go-d-plugin = callPackage ./go.d.plugin.nix {};
in stdenv.mkDerivation rec {
  version = "1.37.1";
  pname = "netdata";

  src = fetchFromGitHub {
    owner = "netdata";
    repo = "netdata";
    rev = "v${version}";
    sha256 = "sha256-SsrdjFENPkI7Ed1gKt28sygJ5NgZ5un+5baIQ3Kv7yE=";
    fetchSubmodules = true;
  };

  strictDeps = true;

  nativeBuildInputs = [ autoreconfHook pkg-config makeWrapper protobuf ];
  buildInputs = [ curl.dev jemalloc libuv zlib.dev ]
    ++ optionals stdenv.isDarwin [ CoreFoundation IOKit libossp_uuid ]
    ++ optionals (!stdenv.isDarwin) [ libcap.dev libuuid.dev ]
    ++ optionals withCups [ cups ]
    ++ optionals withDBengine [ judy lz4.dev ]
    ++ optionals withIpmi [ freeipmi ]
    ++ optionals withNetfilter [ libmnl libnetfilter_acct ]
    ++ optionals withCloud [ json_c ]
    ++ optionals withConnPubSub [ google-cloud-cpp grpc ]
    ++ optionals withConnPrometheus [ snappy ]
    ++ optionals (withCloud || withConnPrometheus) [ protobuf ]
    ++ optionals withSsl [ openssl.dev ];

  patches = [
    # required to prevent plugins from relying on /etc
    # and /var
    ./no-files-in-etc-and-var.patch
    # The current IPC location is unsafe as it writes
    # a fixed path in /tmp, which is world-writable.
    # Therefore we put it into `/run/netdata`, which is owned
    # by netdata only.
    ./ipc-socket-in-run.patch

    # Avoid build-only inputs in closure leaked by configure command:
    #   https://github.com/NixOS/nixpkgs/issues/175693#issuecomment-1143344162
    ./skip-CONFIGURE_COMMAND.patch
  ];

  # Guard against unused buld-time development inputs in closure. Without
  # the ./skip-CONFIGURE_COMMAND.patch patch the closure retains inputs up
  # to bootstrap tools:
  #   https://github.com/NixOS/nixpkgs/pull/175719
  # We pick zlib.dev as a simple canary package with pkg-config input.
  disallowedReferences = [ zlib.dev ];

  NIX_CFLAGS_COMPILE = optionalString withDebug "-O1 -ggdb -DNETDATA_INTERNAL_CHECKS=1";

  postInstall = ''
    ln -s ${go-d-plugin}/lib/netdata/conf.d/* $out/lib/netdata/conf.d
    ln -s ${go-d-plugin}/bin/godplugin $out/libexec/netdata/plugins.d/go.d.plugin
  '' + optionalString (!stdenv.isDarwin) ''
    # rename this plugin so netdata will look for setuid wrapper
    mv $out/libexec/netdata/plugins.d/apps.plugin \
       $out/libexec/netdata/plugins.d/apps.plugin.org
    mv $out/libexec/netdata/plugins.d/cgroup-network \
       $out/libexec/netdata/plugins.d/cgroup-network.org
    mv $out/libexec/netdata/plugins.d/perf.plugin \
       $out/libexec/netdata/plugins.d/perf.plugin.org
    mv $out/libexec/netdata/plugins.d/slabinfo.plugin \
       $out/libexec/netdata/plugins.d/slabinfo.plugin.org
    ${optionalString withIpmi ''
      mv $out/libexec/netdata/plugins.d/freeipmi.plugin \
         $out/libexec/netdata/plugins.d/freeipmi.plugin.org
    ''}
  '';

  preConfigure = optionalString (!stdenv.isDarwin) ''
    substituteInPlace collectors/python.d.plugin/python_modules/third_party/lm_sensors.py \
      --replace 'ctypes.util.find_library("sensors")' '"${lm_sensors.out}/lib/libsensors${stdenv.hostPlatform.extensions.sharedLibrary}"'
  '';

  configureFlags = [
    "--localstatedir=/var"
    "--sysconfdir=/etc"
    "--disable-ebpf"
    "--with-jemalloc=${jemalloc}"
  ] ++ optionals (!withDBengine) [
    "--disable-dbengine"
  ] ++ optionals (!withCloud) [
    "--disable-cloud"
  ];

  postFixup = ''
    wrapProgram $out/bin/netdata-claim.sh --prefix PATH : ${lib.makeBinPath [ openssl ]}
  '';

  enableParallelBuild = true;

  passthru = {
    inherit withIpmi;
    tests.netdata = nixosTests.netdata;
  };

  meta = {
    broken = stdenv.isDarwin;
    description = "Real-time performance monitoring tool";
    homepage = "https://www.netdata.cloud/";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = [ ];
  };
}
