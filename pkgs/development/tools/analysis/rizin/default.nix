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
, python3
}:

stdenv.mkDerivation rec {
  pname = "rizin";
  version = "0.3.4";

  src = fetchurl {
    url = "https://github.com/rizinorg/rizin/releases/download/v${version}/rizin-src-v${version}.tar.xz";
    sha256 = "sha256-7qSbOWOHwJ0ZcFqrAqYXzbFWgvymfxAf8rJ+75SnEOk=";
  };

  mesonFlags = [
    "-Duse_sys_capstone=enabled"
    "-Duse_sys_magic=enabled"
    "-Duse_sys_libzip=enabled"
    "-Duse_sys_zlib=enabled"
    "-Duse_sys_xxhash=enabled"
    "-Duse_sys_lz4=enabled"
    "-Duse_sys_openssl=enabled"
    "-Duse_sys_tree_sitter=enabled"
  ];

  nativeBuildInputs = [ pkg-config meson ninja cmake (python3.withPackages (ps: [ ps.setuptools ])) ];

  # meson's find_library seems to not use our compiler wrapper if static paraemter
  # is either true/false... We work around by also providing LIBRARY_PATH
  preConfigure = ''
    LIBRARY_PATH=""
    for b in ${toString (map lib.getLib buildInputs)}; do
      if [[ -d "$b/lib" ]]; then
        LIBRARY_PATH="$b/lib''${LIBRARY_PATH:+:}$LIBRARY_PATH"
      fi
    done
    export LIBRARY_PATH
  '';

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
  };
}
