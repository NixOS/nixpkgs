{ lib
, stdenv
, fetchFromGitHub
, buildPackages
, pkg-config
, meson
, ninja
, libusb-compat-0_1
, readline
, libewf
, perl
, zlib
, openssl
, libuv
, file
, libzip
, xxHash
, gtk2
, vte
, gtkdialog
, python3
, ruby
, lua
, lz4
, capstone
, useX11 ? false
, rubyBindings ? false
, luaBindings ? false
}:

let
  # NOTE: Check these revision changes when updating the package.
  # https://github.com/radareorg/radare2/blob/master/libr/arch/p/arm/v35/Makefile#L25-L26
  arm64 = fetchFromGitHub {
    owner = "radareorg";
    repo = "vector35-arch-arm64";
    rev = "55d73c6bbb94448a5c615933179e73ac618cf876";
    hash = "sha256-pZxxp5xDg8mgkGEx7LaBSoKxNPyggFYA4um9YaO20LU=";
  };
  armv7 = fetchFromGitHub {
    owner = "radareorg";
    repo = "vector35-arch-armv7";
    rev = "f270a6cc99644cb8e76055b6fa632b25abd26024";
    hash = "sha256-YhfgJ7M8ys53jh1clOzj0I2yfJshXQm5zP0L9kMYsmk=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "radare2";
  version = "5.9.2";

  src = fetchFromGitHub {
    owner = "radare";
    repo = "radare2";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-smsjGfTvSTVwd7nhWhptYpkus2fEQ2EVdT5bDt/rHZE=";
  };

  preBuild = ''
    pushd ../libr/arch/p/arm/v35
    cp -r ${arm64} arch-arm64
    chmod -R +w arch-arm64

    cp -r ${armv7} arch-armv7
    chmod -R +w arch-armv7
    popd
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isDarwin ''
    install_name_tool -add_rpath $out/lib $out/lib/libr_io.${finalAttrs.version}.dylib
  '';

  mesonFlags = [
   "-Dr2_gittap=${finalAttrs.version}"
   "-Duse_sys_capstone=true"
   "-Duse_sys_lz4=true"
   "-Duse_sys_magic=true"
   "-Duse_sys_openssl=true"
   "-Duse_sys_xxhash=true"
   "-Duse_sys_zip=true"
  ];

  enableParallelBuilding = true;

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  strictDeps = true;

  nativeBuildInputs = [ pkg-config meson ninja python3 ];

  buildInputs = [
    capstone
    file
    readline
    libusb-compat-0_1
    libewf
    perl
    zlib
    openssl
    libuv
    lz4
  ] ++ lib.optionals useX11 [ gtkdialog vte gtk2 ]
    ++ lib.optionals rubyBindings [ ruby ]
    ++ lib.optionals luaBindings [ lua ];

  propagatedBuildInputs = [
    # radare2 exposes r_lib which depends on these libraries
    file # for its list of magic numbers (`libmagic`)
    libzip
    xxHash
  ];

  meta = with lib; {
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
    license = with licenses; [ gpl3Only lgpl3Only ];
    maintainers = with maintainers; [ azahi raskin makefu mic92 arkivm ];
    mainProgram = "radare2";
    platforms = platforms.unix;
  };
})
