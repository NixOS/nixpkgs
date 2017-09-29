{ stdenv, fetchgit, autoreconfHook, openssl, libpcap, dpdk }:

stdenv.mkDerivation rec {
  name = "odp-dpdk-${version}";
  version = "1.15.0.0";

  src = fetchgit {
    url = "https://git.linaro.org/lng/odp-dpdk.git";
    rev = "d8533b4e575d62c9f6f2caedd38d98a1a56fb8d3";
    sha256 = "1p09rw7dxxqcxxrdb8wbwp2imapyjvdbvap7s9km2i9hbd8ipdif";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ openssl dpdk libpcap ];

  RTE_SDK = "${dpdk}";
  RTE_TARGET = "x86_64-native-linuxapp-gcc";

  dontDisableStatic = true;

  configureFlags = [
    "--disable-shared"
    "--with-sdk-install-path=${dpdk}/${RTE_TARGET}"
  ];

  patches = [
    ./configure.patch
    ./odp_crypto.patch
  ];

  meta = with stdenv.lib; {
    description = "Open Data Plane optimized for DPDK";
    homepage = http://www.opendataplane.org;
    license = licenses.bsd3;
    platforms =  [ "x86_64-linux" ];
    maintainers = [ maintainers.abuibrahim ];
  };
}
