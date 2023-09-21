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
  # FIXME: Compare revision with
  # https://github.com/radareorg/radare2/blob/master/libr/asm/arch/arm/v35arm64/Makefile#L26-L27
  arm64 = fetchFromGitHub {
    owner = "radareorg";
    repo = "vector35-arch-arm64";
    rev = "c9e7242972837ac11fc94db05fabcb801a8269c9";
    hash = "sha256-HFQj23GlLAyyzMGnPq40XaPv5qPDHdDlQOo0Hprc9Cs=";
  };
  armv7 = fetchFromGitHub {
    owner = "radareorg";
    repo = "vector35-arch-armv7";
    rev = "dde39f69ffea19fc37e681874b12cb4707bc4f30";

    hash = "sha256-bnWQc0dScM9rhIdzf+iVXvMqYWq/bguEAUQPaZRgdlU=";
  };
in
stdenv.mkDerivation rec {
  pname = "radare2";
  version = "5.7.8";

  src = fetchFromGitHub {
    owner = "radare";
    repo = "radare2";
    rev = version;
    hash = "sha256-+/9SeILuDCUaYwPhhN6z3vQFicd1Bh8N/yicZTybR5o=";
  };

  preBuild = ''
    cp -r ${arm64} ../libr/asm/arch/arm/v35arm64/arch-arm64
    chmod -R +w ../libr/asm/arch/arm/v35arm64/arch-arm64

    cp -r ${armv7} ../libr/asm/arch/arm/v35arm64/arch-armv7
    chmod -R +w ../libr/asm/arch/arm/v35arm64/arch-armv7
  '';

  postFixup = lib.optionalString stdenv.isDarwin ''
    install_name_tool -add_rpath $out/lib $out/lib/libr_io.${version}.dylib
  '';

  mesonFlags = [
   "-Duse_sys_capstone=true"
   "-Duse_sys_magic=true"
   "-Duse_sys_zip=true"
   "-Duse_sys_xxhash=true"
   "-Duse_sys_lz4=true"
   "-Dr2_gittap=${version}"
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
    description = "UNIX-like reverse engineering framework and command-line tools";
    homepage = "https://radare.org";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ azahi raskin makefu mic92 arkivm ];
    platforms = platforms.unix;
  };
}
