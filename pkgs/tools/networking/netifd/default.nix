{ runCommand, stdenv, cmake, fetchgit, libnl, libubox, uci, ubus, json_c }:

stdenv.mkDerivation {
  pname = "netifd";
  version = "unstable-2020-01-18";

  src = fetchgit {
    url = "https://git.openwrt.org/project/netifd.git";
    rev = "1321c1bd8fe921986c4eb39c3783ddd827b79543";
    sha256 = "178pckyf1cydi6zzr4bmhksv8vyaks91zv9lqqd2z5nkmccl6vf3";
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
