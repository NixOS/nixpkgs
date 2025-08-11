{
  lib,
  stdenv,
  fetchurl,
  cmake,
  ninja,
  pkg-config,
  perl,
  go,
  python3,
  protobuf,
  zlib,
  gtest,
  brotli,
  lz4,
  zstd,
  pcre2,
  fetchpatch2,
  fmt,
  udev,
}:

let
  pythonEnv = python3.withPackages (ps: [ ps.protobuf ]);
in

stdenv.mkDerivation rec {
  pname = "android-tools";
  version = "35.0.2";

  src = fetchurl {
    url = "https://github.com/nmeum/android-tools/releases/download/${version}/android-tools-${version}.tar.xz";
    hash = "sha256-0sMiIoAxXzbYv6XALXYytH42W/4ud+maNWT7ZXbwQJc=";
  };

  patches = [
    (fetchpatch2 {
      url = "https://gitlab.archlinux.org/archlinux/packaging/packages/android-tools/-/raw/dd0234790b42b48567b64a3024fc2ec6c7ab6c21/android-tools-35.0.2-fix-protobuf-30.0-compilation.patch";
      stripLen = 1;
      extraPrefix = "vendor/extras/";
      hash = "sha256-WSfU+0XIrxxlCjAIR49l9JvX9C6xCXirhLFHMMvNmJk=";
    })
  ];

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    perl
    go
  ];
  buildInputs = [
    protobuf
    zlib
    gtest
    brotli
    lz4
    zstd
    pcre2
    fmt
    udev
  ];
  propagatedBuildInputs = [ pythonEnv ];

  preConfigure = ''
    export GOCACHE=$TMPDIR/go-cache
  '';

  cmakeFlags = [
    (lib.cmakeBool "CMAKE_FIND_PACKAGE_PREFER_CONFIG" true)
    (lib.cmakeBool "protobuf_MODULE_COMPATIBLE" true)
    (lib.cmakeBool "ANDROID_TOOLS_LIBUSB_ENABLE_UDEV" true)
    (lib.cmakeBool "ANDROID_TOOLS_USE_BUNDLED_LIBUSB" true)
  ];

  meta = {
    description = "Android SDK platform tools";
    longDescription = ''
      Android SDK Platform-Tools is a component for the Android SDK. It
      includes tools that interface with the Android platform, such as adb and
      fastboot. These tools are required for Android app development. They're
      also needed if you want to unlock your device bootloader and flash it
      with a new system image.
      Currently the following tools are supported:
      - adb
      - fastboot
      - mke2fs.android (required by fastboot)
      - simg2img, img2simg, append2simg
      - lpdump, lpmake, lpadd, lpflash, lpunpack
      - mkbootimg, unpack_bootimg, repack_bootimg, avbtool
      - mkdtboimg
    '';
    # https://developer.android.com/studio/command-line#tools-platform
    # https://developer.android.com/studio/releases/platform-tools
    homepage = "https://github.com/nmeum/android-tools";
    license = with lib.licenses; [
      asl20
      unicode-dfs-2015
      mit
    ];
    platforms = lib.platforms.unix;
    teams = [ lib.teams.android ];
  };
}
