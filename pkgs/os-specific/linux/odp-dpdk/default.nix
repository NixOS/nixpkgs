{ stdenv, fetchurl, autoreconfHook, pkgconfig
, dpdk, libconfig, libpcap, numactl, openssl
}:

stdenv.mkDerivation rec {
  pname = "odp-dpdk";
  version = "1.19.0.0_DPDK_17.11";

  src = fetchurl {
    url = "https://git.linaro.org/lng/odp-dpdk.git/snapshot/${pname}-${version}.tar.gz";
    sha256 = "05bwjaxl9hqc6fbkp95nniq11g3kvzmlxw0bq55i7p2v35nv38px";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ dpdk libconfig libpcap numactl openssl ];

  RTE_SDK = "${dpdk}/share/dpdk";
  RTE_TARGET = "x86_64-native-linuxapp-gcc";

  dontDisableStatic = true;

  configureFlags = [
    "--disable-shared"
    "--with-dpdk-path=${dpdk}"
  ];

  meta = with stdenv.lib; {
    description = "Open Data Plane optimized for DPDK";
    homepage = https://www.opendataplane.org;
    license = licenses.bsd3;
    platforms =  [ "x86_64-linux" ];
    maintainers = [ maintainers.abuibrahim ];
  };
}
