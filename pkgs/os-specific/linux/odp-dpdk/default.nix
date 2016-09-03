{ stdenv, fetchgit, autoreconfHook, openssl, libpcap, dpdk }:

stdenv.mkDerivation rec {
  name = "odp-dpdk-${version}";
  version = "2016-08-16";

  src = fetchgit {
    url = "https://git.linaro.org/lng/odp-dpdk.git";
    rev = "7068593f600e2b5a23ee1780d5c722c54e966df1";
    sha256 = "0pz0zkxqaac193x21wmj3x88gfza6bvhmv5yf8fzkpm9zxnl2sy4";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ openssl dpdk libpcap ];

  RTE_SDK = "${dpdk}";
  RTE_TARGET = "x86_64-native-linuxapp-gcc";

  patchPhase = ''
    substituteInPlace scripts/git_hash.sh --replace /bin/bash /bin/sh
    substituteInPlace scripts/get_impl_str.sh --replace /bin/bash /bin/sh
    echo -n ${version} > .scmversion
  '';

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
