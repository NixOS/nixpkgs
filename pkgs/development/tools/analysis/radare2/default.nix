{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPackages,
  capstone,
  file,
  gtk2,
  gtkdialog,
  libewf,
  libusb-compat-0_1,
  libuv,
  libzip,
  lua,
  lz4,
  meson,
  ninja,
  openssl,
  perl,
  pkg-config,
  python3,
  readline,
  ruby,
  vte,
  xxHash,
  zlib,
  useX11 ? false,
  rubyBindings ? false,
  luaBindings ? false,
}:
let
  binaryninja = fetchFromGitHub {
    owner = "Vector35";
    repo = "binaryninja-api";
    rev = "ba13f6ec7d0ce9a18a03a1c895fb72d18e03014a"; # https://github.com/radareorg/radare2/blob/master/subprojects/binaryninja.wrap
    hash = "sha256-ApBDmrepz27ioEjtqgdGzGF0tPkDghp7dA8L9eHHW6w=";
  };

  sdb = fetchFromGitHub {
    owner = "radareorg";
    repo = "sdb";
    tag = "2.4.2"; # https://github.com/radareorg/radare2/blob/master/subprojects/sdb.wrap
    hash = "sha256-JN27SkDqHtX83d1CPUF9hbVKwE/dwhDgn5MlCX9RPrc=";
  };

  qjs = fetchFromGitHub {
    owner = "quickjs-ng";
    repo = "quickjs";
    rev = "e2b100e8c5fa7131e9fb22b8a0e9ca0f16eb9892"; # https://github.com/radareorg/radare2/blob/master/subprojects/qjs.wrap
    hash = "sha256-vq+K93MuvFC+JKw4623gKs53ngw1097l5Kf/RBGU+mA=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "radare2";
  version = "6.1.2";

  src = fetchFromGitHub {
    owner = "radare";
    repo = "radare2";
    tag = finalAttrs.version;
    hash = "sha256-YiKbXKKwbeAUkeq4LcUwOxTHU1Hua4YhcwDULiHVmrQ=";
  };

  mesonFlags = [
    (lib.mesonBool "use_sys_capstone" true)
    (lib.mesonBool "use_sys_lz4" true)
    (lib.mesonBool "use_sys_magic" true)
    (lib.mesonBool "use_sys_openssl" true)
    (lib.mesonBool "use_sys_xxhash" true)
    (lib.mesonBool "use_sys_zip" true)
    (lib.mesonBool "use_sys_zlib" true)
    (lib.mesonOption "r2_gittap" finalAttrs.version)
  ];

  enableParallelBuilding = true;

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    python3
  ];

  buildInputs = [
    capstone
    file
    libewf
    libusb-compat-0_1
    libuv
    lz4
    openssl
    perl
    readline
    zlib
  ]
  ++ lib.optionals useX11 [
    gtkdialog
    vte
    gtk2
  ]
  ++ lib.optionals rubyBindings [ ruby ]
  ++ lib.optionals luaBindings [ lua ];

  propagatedBuildInputs = [
    # radare2 exposes r_lib which depends on these libraries
    file # for its list of magic numbers (`libmagic`)
    libzip
    xxHash
  ];

  postUnpack = ''
    pushd $sourceRoot/subprojects

    cp -r ${binaryninja} binaryninja
    chmod -R +w binaryninja
    cp packagefiles/binaryninja/meson.build binaryninja

    cp -r ${sdb} sdb
    chmod -R +w sdb

    cp -r ${qjs} qjs
    chmod -R +w qjs
    cp packagefiles/qjs/meson.build qjs

    popd
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isDarwin ''
    install_name_tool -add_rpath $out/lib $out/lib/libr_io.${finalAttrs.version}.dylib
  '';

  meta = {
    description = "UNIX-like reverse engineering framework and command-line toolset";
    longDescription = ''
      r2 is a complete rewrite of radare. It provides a set of libraries, tools
      and plugins to ease reverse engineering tasks. Distributed mostly under
      LGPLv3, each plugin can have different licenses.

      The radare project started as a simple command-line hexadecimal editor
      focused on forensics. Today, r2 is a featureful low-level command-line
      tool with support for scripting with the embedded JavaScript interpreter
      or via r2pipe.

      r2 can edit files on local hard drives, view kernel memory, and debug
      programs locally or via a remote gdb/windbg servers. r2's wide
      architecture support allows you to analyze, emulate, debug, modify, and
      disassemble any binary.
    '';
    homepage = "https://radare.org";
    changelog = "https://github.com/radareorg/radare2/releases/tag/${finalAttrs.version}";
    license = with lib.licenses; [
      gpl3Only
      lgpl3Only
    ];
    maintainers = with lib.maintainers; [
      arkivm
      azahi
      makefu
      mic92
      raskin
    ];
    mainProgram = "radare2";
    platforms = lib.platforms.unix;
  };
})
