{ lib
, stdenv
, fetchurl
, pkg-config
, libusb-compat-0_1
, readline
, libewf
, perl
, zlib
, openssl
, libuv
, file
, libzip
, lz4
, xxHash
, meson
, cmake
, ninja
, capstone
, tree-sitter
}:

stdenv.mkDerivation rec {
  pname = "rizin";
  version = "0.1.2";

  src = fetchurl {
    url = "https://github.com/rizinorg/rizin/releases/download/v${version}/rizin-src-${version}.tar.xz";
    sha256 = "sha256-npUp8wJiKAaQKSigXtndhJLTJ4+pyFqa0FwDLBqR/sE=";
  };

  mesonFlags = [
    "-Duse_sys_capstone=true"
    "-Duse_sys_magic=true"
    "-Duse_sys_libzip=true"
    "-Duse_sys_zlib=true"
    "-Duse_sys_xxhash=true"
    "-Duse_sys_lz4=true"
    "-Duse_sys_openssl=true"
    "-Duse_sys_tree_sitter=true"
  ];

  nativeBuildInputs = [ pkg-config meson ninja cmake ];

  buildInputs = [
    file
    libzip
    capstone
    readline
    libusb-compat-0_1
    libewf
    perl
    zlib
    lz4
    openssl
    libuv
    tree-sitter
    xxHash
  ];

  meta = {
    description = "UNIX-like reverse engineering framework and command-line toolset.";
    homepage = "https://rizin.re/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ raskin makefu mic92 ];
    platforms = with lib.platforms; linux;
    inherit version;
  };
}
