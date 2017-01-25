{ stdenv, fetchgit, autoreconfHook, openssl, libpcap, dpdk }:

stdenv.mkDerivation rec {
  name = "odp-dpdk-${version}";
  version = "1.12.0.0";

  src = fetchgit {
    url = "https://git.linaro.org/lng/odp-dpdk.git";
    rev = "5e370e1113973feafb43a8e57d4c59be40e9aeab";
    sha256 = "0rrakbxnbsqaj148xaz2hwxjvg3cmzlynfkvcp8w56sqyly75d0n";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ openssl dpdk libpcap ];

  RTE_SDK = "${dpdk}";
  RTE_TARGET = "x86_64-native-linuxapp-gcc";

  dontDisableStatic = true;

  configureFlags = [
    "--with-platform=linux-dpdk"
    "--disable-shared"
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
