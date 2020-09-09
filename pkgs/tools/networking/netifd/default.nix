{ runCommand, stdenv, cmake, fetchgit, libnl, libubox, uci, ubus, json_c }:

stdenv.mkDerivation {
  pname = "netifd";
  version = "unstable-2020-07-11";

  src = fetchgit {
    url = "https://git.openwrt.org/project/netifd.git";
    rev = "3d9bd73e8c2d8a1f78effbe92dd2495bbd2552c4";
    sha256 = "085sx1gsigbi1jr19l387rc5p6ja1np6q2gb84khjd4pyiqwk840";
  };

  buildInputs = [ libnl libubox uci ubus json_c ];
  nativeBuildInputs = [ cmake ];

  preBuild = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE \
      -I$(echo "${stdenv.lib.getDev libnl}"/include/libnl*/)"
  '';

  meta = with stdenv.lib; {
    description = "OpenWrt Network interface configuration daemon";
    homepage = "https://git.openwrt.org/?p=project/netifd.git;a=summary";
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = with maintainers; [ petabyteboy ];
  };
}
