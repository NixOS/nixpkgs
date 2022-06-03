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
  # FIXME: Compare revision with https://github.com/radareorg/radare2/blob/master/libr/asm/arch/arm/v35arm64/Makefile#L20
  arm64 = fetchFromGitHub {
    owner = "radareorg";
    repo = "vector35-arch-arm64";
    rev = "3c5eaba46dab72ecb7d5f5b865a13fdeee95b464";
    sha256 = "sha256-alcGEi+D8CptXzfznnuxQKCvU2mbzn2sQge5jSqLVpg=";
  };
  armv7 = fetchFromGitHub {
    owner = "radareorg";
    repo = "vector35-arch-armv7";
    rev = "dde39f69ffea19fc37e681874b12cb4707bc4f30";

    sha256 = "sha256-bnWQc0dScM9rhIdzf+iVXvMqYWq/bguEAUQPaZRgdlU=";
  };
in
stdenv.mkDerivation rec {
  pname = "radare2";
  version = "5.6.8";

  src = fetchFromGitHub {
    owner = "radare";
    repo = "radare2";
    rev = version;
    sha256 = "0fpz63dfac1i6wwf5wp3v1vs3r5yzh05g95m5vidx56h0g4dcp44";
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

  WITHOUT_PULL = "1";
  makeFlags = [
    "GITTAP=${version}"
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
  ] ++ lib.optional useX11 [ gtkdialog vte gtk2 ]
    ++ lib.optional rubyBindings [ ruby ]
    ++ lib.optional pythonBindings [ python3 ]
    ++ lib.optional luaBindings [ lua ];

  propagatedBuildInputs = [
    # radare2 exposes r_lib which depends on these libraries
    file # for its list of magic numbers (`libmagic`)
    libzip
    xxHash
  ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "unix-like reverse engineering framework and commandline tools";
    homepage = "https://radare.org/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ raskin makefu mic92 arkivm ];
    platforms = platforms.unix;
  };
}
