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
, python3
, cmake
, ninja
, capstone
, tree-sitter
}:

stdenv.mkDerivation rec {
  pname = "rizin";
  version = "0.4.1";

  src = fetchurl {
    url = "https://github.com/rizinorg/rizin/releases/download/v${version}/rizin-src-v${version}.tar.xz";
    sha256 = "sha256-Zp2Va5l4IKNuQjzzXUgqqZhJJUuWWM72hERZkS39v7g=";
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

  nativeBuildInputs = [
    pkg-config
    meson
    (python3.withPackages (pp: with pp; [
      pyyaml
    ]))
    ninja
    cmake
  ];

  # meson's find_library seems to not use our compiler wrapper if static parameter
  # is either true/false... We work around by also providing LIBRARY_PATH
  preConfigure = ''
    LIBRARY_PATH=""
    for b in ${toString (map lib.getLib buildInputs)}; do
      if [[ -d "$b/lib" ]]; then
        LIBRARY_PATH="$b/lib''${LIBRARY_PATH:+:}$LIBRARY_PATH"
      fi
    done
    export LIBRARY_PATH
  '' + lib.optionalString stdenv.isDarwin ''
    substituteInPlace binrz/rizin/macos_sign.sh \
      --replace 'codesign' '# codesign'
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

  postPatch = ''
    # find_installation without arguments uses Meson’s Python interpreter,
    # which does not have any extra modules.
    # https://github.com/mesonbuild/meson/pull/9904
    substituteInPlace meson.build \
      --replace "import('python').find_installation()" "find_program('python3')"
  '';

  meta = {
    description = "UNIX-like reverse engineering framework and command-line toolset.";
    homepage = "https://rizin.re/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ raskin makefu mic92 ];
    platforms = with lib.platforms; unix;
  };
}
