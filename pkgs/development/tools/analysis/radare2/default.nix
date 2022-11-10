{ lib
, stdenv
, fetchFromGitHub
, buildPackages
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
, xxHash
, gtk2
, vte
, gtkdialog
, python3
, ruby
, lua
, capstone
, useX11 ? false
, rubyBindings ? false
, pythonBindings ? false
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
    cp -r ${arm64} libr/asm/arch/arm/v35arm64/arch-arm64
    chmod -R +w libr/asm/arch/arm/v35arm64/arch-arm64

    cp -r ${armv7} libr/asm/arch/arm/v35arm64/arch-armv7
    chmod -R +w libr/asm/arch/arm/v35arm64/arch-armv7
  '';

  postFixup = lib.optionalString stdenv.isDarwin ''
    for file in $out/bin/rasm2 $out/bin/ragg2 $out/bin/rabin2 $out/lib/libr_asm.${version}.dylib $out/lib/libr_anal.${version}.dylib; do
      install_name_tool -change libcapstone.4.dylib ${capstone}/lib/libcapstone.4.dylib $file
    done
  '';

  makeFlags = [
    "WITHOUT_PULL=1"
    "R2_GITTAP=${version}"
    "RANLIB=${stdenv.cc.bintools.bintools}/bin/${stdenv.cc.bintools.targetPrefix}ranlib"
    "CC=${stdenv.cc.targetPrefix}cc"
    "HOST_CC=${stdenv.cc.targetPrefix}cc"
  ];

  configureFlags = [
    "--with-sysmagic"
    "--with-syszip"
    "--with-sysxxhash"
    "--with-syscapstone"
    "--with-openssl"
  ];

  enableParallelBuilding = true;
  depsBuildBuild = [ buildPackages.stdenv.cc ];

  nativeBuildInputs = [ pkg-config ];
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
  ] ++ lib.optionals useX11 [ gtkdialog vte gtk2 ]
    ++ lib.optionals rubyBindings [ ruby ]
    ++ lib.optionals pythonBindings [ python3 ]
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
