{ stdenv, fetchurl, autoreconfHook, pkgconfig
, dpdk, libconfig, libpcap, numactl, openssl, zlib, libbsd, libelf, jansson
}: let
  dpdk_18_11 = dpdk.overrideAttrs (old: rec {
    version = "18.11.5";
    src = fetchurl {
      url = "https://fast.dpdk.org/rel/dpdk-${version}.tar.xz";
      sha256 = "1n6nfaj7703l19jcw540lm8avni48hj9q1rq4mfp8b8gd4zjprj0";
    };
  });

in stdenv.mkDerivation rec {
  pname = "odp-dpdk";
  version = "1.22.0.0_DPDK_18.11";

  src = fetchurl {
    url = "https://git.linaro.org/lng/odp-dpdk.git/snapshot/${pname}-${version}.tar.gz";
    sha256 = "1m8xhmfjqlj2gkkigq5ka3yh0xgzrcpfpaxp1pnh8d1g99094vbx";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkgconfig
  ];
  buildInputs = [
    dpdk_18_11
    libconfig
    libpcap
    numactl
    openssl
    zlib
    libbsd
    libelf
    jansson
  ];

  NIX_CFLAGS_COMPILE = [ "-Wno-error=address-of-packed-member" ];

  # for some reason, /build/odp-dpdk-1.22.0.0_DPDK_18.11/lib/.libs ends up in all binaries,
  # while it should be $out/lib instead.
  # prepend rpath with the proper location, the /build will get removed during rpath shrinking
  preFixup = ''
    for prog in $out/bin/*; do
      patchelf --set-rpath $out/lib:`patchelf --print-rpath $prog` $prog
    done
  '';

  # binaries will segfault otherwise
  dontStrip = true;

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Open Data Plane optimized for DPDK";
    homepage = https://www.opendataplane.org;
    license = licenses.bsd3;
    platforms =  platforms.linux;
    maintainers = [ maintainers.abuibrahim ];
  };
}
