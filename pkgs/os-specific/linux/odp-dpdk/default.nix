{ lib
, stdenv
, fetchurl
, autoreconfHook
, pkg-config
, dpdk
, libbpf
, libconfig
, libpcap
, numactl
, openssl
, zlib
, libbsd
, libelf
, jansson
, libnl
}:

stdenv.mkDerivation rec {
  pname = "odp-dpdk";
  version = "1.41.0.0_DPDK_22.11";

  src = fetchurl {
    url = "https://git.linaro.org/lng/odp-dpdk.git/snapshot/${pname}-${version}.tar.gz";
    hash = "sha256-4p+R+7IeDKQFqBzQTvXfR407exxhoS8pnKxF9Qnr8tw=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    dpdk
    libconfig
    libpcap
    numactl
    openssl
    zlib
    libbsd
    libelf
    jansson
    libbpf
    libnl
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
