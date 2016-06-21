{ stdenv, fetchgit, autoreconfHook, openssl, libpcap, dpdk, bash }:

stdenv.mkDerivation rec {
  name = "odp-dpdk-${version}";
  version = "1.8.0.0";

  src = fetchgit {
    url = "https://git.linaro.org/lng/odp-dpdk.git";
    rev = "438a207a39bad213cdc03929452a8199caef5d8c";
    sha256 = "0k4g5zbirbfdcgqz0nbn9san66y178qnigyvrr2apj3apzjjy7zv";
  };

  nativeBuildInputs = [ autoreconfHook bash ];
  buildInputs = [ stdenv openssl dpdk libpcap ];

  RTE_SDK = "${dpdk}";
  RTE_TARGET = "x86_64-native-linuxapp-gcc";

  patchPhase = ''
    substituteInPlace scripts/git_hash.sh --replace /bin/bash /bin/sh
    echo -n ${version} > .scmversion
  '';

  dontDisableStatic = true;

  configureFlags = [
    "--with-platform=linux-dpdk"
    "--disable-shared"
    "--disable-shared-dpdk"
    "--with-sdk-install-path=${dpdk}/${RTE_TARGET}"
  ];

  meta = with stdenv.lib; {
    description = "Open Data Plane optimized for DPDK";
    homepage = http://www.opendataplane.org;
    license = licenses.bsd3;
    platforms =  [ "x86_64-linux" ];
    maintainers = [ maintainers.abuibrahim ];
  };
}
