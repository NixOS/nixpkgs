{ lib
, llvmPackages_14
, fetchgit
, fetchurl
, callPackage
, cmake
, dpdk
, intel-ipsec-mb
, xdp-tools
, libbpf
, libmnl
, elfutils
, zlib
, rdma-core
, python310
, python310Packages
, openssl
, libuuid
, subunit
, pkg-config
, libpcap
, jansson
, libnl
, libdaq
, srtp
, mbedtls_2
, check
, nixosTests
}:

let
  stdenv = llvmPackages_14.stdenv;

  xdp-tools' = xdp-tools.overrideAttrs (old: rec {
    postInstall = ''
      # Drop unfortunate references to glibc.dev/include at least from $lib
      nuke-refs "$lib"/lib/bpf/*.o
    '';
  });

  intel-ipsec-mb' = intel-ipsec-mb.overrideAttrs (old: rec {
    makeFlags = old.makeFlags ++ [
      "SHARED=n"
    ];
  });

  dpdk' = dpdk.overrideAttrs (old: rec {
    version = "22.07";
    src = fetchurl {
      url = "https://fast.dpdk.org/rel/dpdk-${version}.tar.xz";
      sha256 = "sha256-n2Tf3gdf21cIy2Leg4uP+4kVdf7R4dKusma6yj38m+o";
    };
  });

  rdma-core' = rdma-core.overrideAttrs (old: rec {
    cmakeFlags = old.cmakeFlags ++ [
      "-DENABLE_STATIC=1"
    ];
  });

  srtp' = srtp.overrideAttrs (old: rec {
    mesonFlags = old.mesonFlags ++ [
      "-Ddefault_library=static"
    ];
  });
in
stdenv.mkDerivation rec {
  pname = "vpp";
  version = "23.06";
  src = fetchgit {
    url = "https://gerrit.fd.io/r/vpp";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-9dn/rpjouwjFUFoQYd8Go1rV4ThZ8gh/egIuXfdPys0=";
  };

  patches = [
    ./0001-fix-nsh-plugin-loading.patch
    ./0002-explicity-include-std-array.patch
  ];

  sourceRoot = "vpp/src";

  quicly = callPackage ./quicly { };

  nativeBuildInputs = [ llvmPackages_14.clang cmake dpdk' intel-ipsec-mb' xdp-tools' libbpf libmnl elfutils zlib quicly rdma-core' python310 python310Packages.ply openssl libuuid subunit pkg-config libpcap jansson libnl libdaq srtp' mbedtls_2 check ];

  hardeningDisable = [ "fortify" "bindnow" ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=release"
    "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}"
    "-DVPP_USE_SYSTEM_DPDK=ON"
  ];

  configurePhase = ''
    # Replace script to get version from git describe
    echo "echo ${version}-release" > scripts/version

    # Replace hard-coded bash with one that can be referenced from
    # the built environment
    substituteInPlace scripts/generate_version_h \
      --replace "#!/bin/bash" "#!$(command -v bash)"

    # Remove pkg from subdirectory to be built
    substituteInPlace CMakeLists.txt --replace \
      "plugins tools/vppapigen tools/g2 tools/perftool cmake pkg" \
      "plugins tools/vppapigen tools/g2 tools/perftool cmake"

     # Replace hard-coded python with one that can be referenced from
     # the built environment
    substituteInPlace \
      tools/vppapigen/vppapigen \
      vpp-api/vapi/vapi_c_gen.py \
      vpp-api/vapi/vapi_cpp_gen.py \
      vpp-api/vapi/vapi_json_parser.py \
      --replace "#!/usr/bin/env python3" "#!$(command -v python)"

    cmake $cmakeFlags .
  '';

  meta = with lib; {
    homepage = "https://fd.io/";
    description =
      "VPP is a fast, scalable layer 2-4 multi-platform network stack";
    longDescription = ''
      FD.io's Vector Packet Processor (VPP) is a fast, scalable layer 2-4
      multi-platform network stack. It runs in Linux Userspace on multiple
      architectures including x86, ARM, and Power architectures.

      VPP's high performance network stack is quickly becoming the network
      stack of choice for applications around the world.

      VPP is continually being enhanced through the extensive use of plugins.
      The Data Plane Development Kit (DPDK) is a great example of this. It
      provides some important features and drivers for VPP.

      VPP supports integration with OpenStack and Kubernetes. Network
      management features include configuration, counters, sampling and more.
      For developers, VPP includes high-performance event-logging, and
      multiple kinds of packet tracing. Development debug images include
      complete symbol tables, and extensive consistency checking.

      Some VPP Use-cases include vSwitches, vRouters, Gateways, Firewalls and
      Load-Balancers, to name a few.
    '';
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ cariandrum22 ];
    platforms = platforms.unix;
  };

  passthru.tests = { inherit (nixosTests) vpp; };
}
