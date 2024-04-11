{ lib
, stdenv
, cmake
, fetchgit
, libnl
, libubox
, uci
, ubus
, json_c
, pkg-config
, udebug
}:

stdenv.mkDerivation {
  pname = "netifd";
  version = "unstable-2023-11-27";

  src = fetchgit {
    url = "https://git.openwrt.org/project/netifd.git";
    rev = "02bc2e14d1d37500e888c0c53ac41398a56b5579";
    hash = "sha256-aMs/Y50+1Yk/j5jGubjBCRcPGw03oIitvEygaxRlr90=";
  };

  buildInputs = [
    libnl.dev
    libubox
    uci
    ubus
    json_c
    udebug
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  postPatch = ''
    # by default this assumes the build directory is the source directory
    # since we let cmake build in it's own build directory, we need to use
    # $PWD (which at the time of this script being run is the directory with the source code)
    # to adjust the paths
    sed "s|./make_ethtool_modes_h.sh|$PWD/make_ethtool_modes_h.sh|g" -i CMakeLists.txt
    sed "s|./ethtool-modes.h|$PWD/ethtool-modes.h|g" -i CMakeLists.txt
  '';

  env.NIX_CFLAGS_COMPILE = toString (lib.optionals (stdenv.cc.isGNU && lib.versionAtLeast stdenv.cc.version "12") [
    "-Wno-error=maybe-uninitialized"
  ]);

  meta = with lib; {
    description = "OpenWrt Network interface configuration daemon";
    homepage = "https://git.openwrt.org/?p=project/netifd.git;a=summary";
    license = licenses.lgpl21Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mkg20001 ];
    mainProgram = "netifd";
  };
}
