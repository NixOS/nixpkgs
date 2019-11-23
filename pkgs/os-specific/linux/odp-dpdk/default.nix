{ stdenv, fetchurl, autoreconfHook, pkgconfig
, dpdk, libconfig, libpcap, numactl, openssl
}: let

  dpdk_17_11 = dpdk.overrideAttrs (old: rec {
    version = "17.11.6";
    src = fetchurl {
      url = "https://fast.dpdk.org/rel/dpdk-${version}.tar.xz";
      sha256 = "0g4l6yjcn17n18c7q1pxkmnj4fg2kiv0krz7n2vjjsb8s6gmbps2";
    };
  });

in stdenv.mkDerivation rec {
  pname = "odp-dpdk";
  version = "1.19.0.0_DPDK_17.11";

  src = fetchurl {
    url = "https://git.linaro.org/lng/odp-dpdk.git/snapshot/${pname}-${version}.tar.gz";
    sha256 = "05bwjaxl9hqc6fbkp95nniq11g3kvzmlxw0bq55i7p2v35nv38px";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ dpdk_17_11 libconfig libpcap numactl openssl ];

  RTE_SDK = "${dpdk_17_11}/share/dpdk";
  RTE_TARGET = "x86_64-native-linuxapp-gcc";

  dontDisableStatic = true;

  configureFlags = [
    "--disable-shared"
    "--with-dpdk-path=${dpdk_17_11}"
  ];

  meta = with stdenv.lib; {
    description = "Open Data Plane optimized for DPDK";
    homepage = https://www.opendataplane.org;
    license = licenses.bsd3;
    platforms =  [ "x86_64-linux" ];
    maintainers = [ maintainers.abuibrahim ];
  };
}
