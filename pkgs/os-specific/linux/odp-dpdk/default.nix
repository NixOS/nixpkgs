{ stdenv, fetchgit, autoreconfHook, openssl, libpcap, dpdk, bash }:

stdenv.mkDerivation rec {
  name = "odp-dpdk-${version}";
  version = "1.10.1.0";

  src = fetchgit {
    url = "https://git.linaro.org/lng/odp-dpdk.git";
    rev = "0ed1ced007d98980f90604675083bf30c354e867";
    sha256 = "1kf090bizr0p0cxn525qpmypb5j86imvxrfpmwbl7vqqfh74j5ax";
  };

  nativeBuildInputs = [ autoreconfHook bash ];
  buildInputs = [ stdenv openssl dpdk libpcap ];

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
