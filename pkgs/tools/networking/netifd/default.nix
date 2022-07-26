{ lib, stdenv, cmake, fetchgit, libnl, libubox, uci, ubus, json_c, pkg-config }:

stdenv.mkDerivation {
  pname = "netifd";
  version = "unstable-2021-04-03";

  src = fetchgit {
    url = "https://git.openwrt.org/project/netifd.git";
    rev = "327da9895327bc56b23413ee91a6e6b6e0e4329d";
    sha256 = "0jvk2hx8kbkc6d72gh9rwap8ds6qgnmny6306vvzxy68v03xikwv";
  };

  buildInputs = [ libnl libubox uci ubus json_c ];
  nativeBuildInputs = [ cmake pkg-config ];

  meta = with lib; {
    description = "OpenWrt Network interface configuration daemon";
    homepage = "https://git.openwrt.org/?p=project/netifd.git;a=summary";
    license = licenses.lgpl21Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}
