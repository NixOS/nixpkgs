{ lib
, stdenv
, fetchurl
, autoreconfHook
, dpdk
, elfutils
, jansson
, libbpf
, libbsd
, libconfig
, libnl
, libpcap
, numactl
, openssl
, pkg-config
, zlib
, zstd
}:

stdenv.mkDerivation rec {
  pname = "odp-dpdk";
  version = "1.42.0.0_DPDK_22.11";

  src = fetchurl {
    url = "https://git.linaro.org/lng/odp-dpdk.git/snapshot/${pname}-${version}.tar.gz";
    hash = "sha256-qtdqYE4+ab6/9Z0YXXCItcfj+3+gyprcNMAnAZkl4GA=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    dpdk
    elfutils
    jansson
    libbpf
    libbsd
    libconfig
    libnl
    libpcap
    numactl
    openssl
    zlib
    zstd
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    # Needed with GCC 12
    "-Wno-error=maybe-uninitialized"
    "-Wno-error=uninitialized"
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
