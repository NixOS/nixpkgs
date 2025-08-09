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
  protobuf_29, # does not build with 30+
  zlib,
  gtest,
  brotli,
  lz4,
  zstd,
  libusb1,
  pcre2,
}:

let
  pythonEnv = python3.withPackages (ps: [ ps.protobuf ]);
in

stdenv.mkDerivation rec {
  pname = "android-tools";
  version = "35.0.1";

  src = fetchurl {
    url = "https://github.com/nmeum/android-tools/releases/download/${version}/android-tools-${version}.tar.xz";
    hash = "sha256-ZUAwx/ltJdciTNaGH6wUoEPPHTmA9AKIzfviGflP+vk=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    perl
    go
  ];
  buildInputs = [
    protobuf_29
    zlib
    gtest
    brotli
    lz4
    zstd
    libusb1
    pcre2
  ];
  propagatedBuildInputs = [ pythonEnv ];

  preConfigure = ''
    export GOCACHE=$TMPDIR/go-cache
  '';

  meta = with lib; {
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
    license = with licenses; [
      asl20
      unicode-dfs-2015
    ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ ];
    teams = [ teams.android ];
  };
}
