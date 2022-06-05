{ lib, stdenv, fetchurl, autoreconfHook, pkg-config
, dpdk, libbpf, libconfig, libpcap, numactl, openssl, zlib, libbsd, libelf, jansson
}: let
  dpdk_19_11 = dpdk.overrideAttrs (old: rec {
    version = "19.11.12";
    src = fetchurl {
      url = "https://fast.dpdk.org/rel/dpdk-${version}.tar.xz";
      sha256 = "sha256-F9m2+MZi3n0psPIwjWwhiIbbNkoGlxqtru2OlV7TbzQ=";
    };
    mesonFlags = old.mesonFlags ++ [
      "-Denable_docs=false"
    ];
  });

in stdenv.mkDerivation rec {
  pname = "odp-dpdk";
  version = "1.35.0.0_DPDK_19.11";

  src = fetchurl {
    url = "https://git.linaro.org/lng/odp-dpdk.git/snapshot/${pname}-${version}.tar.gz";
    sha256 = "sha256-R4cRfz0uUDbeQmJfFSIAmq3KfD6CE9hIW2yvFqL+b0M=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
    dpdk_19_11
    libconfig
    libpcap
    numactl
    openssl
    zlib
    libbsd
    libelf
    jansson
    libbpf
  ];

  # binaries will segfault otherwise
  dontStrip = true;

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Open Data Plane optimized for DPDK";
    homepage = "https://www.opendataplane.org";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = [ maintainers.abuibrahim ];
  };
}
