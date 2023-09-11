{ stdenv, lib, fetchgit, cmake, pkg-config }:

stdenv.mkDerivation {
  pname = "libnl-tiny";
  version = "unstable-2023-07-27";

  src = fetchgit {
    url = "https://git.openwrt.org/project/libnl-tiny.git";
    rev = "bc92a280186f9becc53c0f17e4e43cfbdeec7e7b";
    hash = "sha256-/d6so8hfBOyp8NbUhPZ0aRj6gXO/RLgwCQnAT7N/rF8=";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  preConfigure = ''
    sed -e 's|''${prefix}/@CMAKE_INSTALL_LIBDIR@|@CMAKE_INSTALL_FULL_LIBDIR@|g' \
        -e 's|''${prefix}/@CMAKE_INSTALL_INCLUDEDIR@|@CMAKE_INSTALL_FULL_INCLUDEDIR@|g' \
        -i libnl-tiny.pc.in
  '';

  meta = with lib; {
    description = "Tiny OpenWrt fork of libnl";
    homepage = "https://git.openwrt.org/?p=project/libnl-tiny.git;a=summary";
    license = licenses.isc;
    maintainers = with maintainers; [ mkg20001 ];
    platforms = platforms.all;
  };
}
