{ lib, stdenv, fetchurl, fetchpatch
, cmake, perl, go, python3
, protobuf, zlib, gtest, brotli, lz4, zstd, libusb1, pcre2
}:

let
  pythonEnv = python3.withPackages(ps: [ ps.protobuf ]);
in

stdenv.mkDerivation rec {
  pname = "android-tools";
  version = "33.0.3";

  src = fetchurl {
    url = "https://github.com/nmeum/android-tools/releases/download/${version}/android-tools-${version}.tar.xz";
    hash = "sha256-jOF02reB1d69Ke0PllciMfd3vuGbjvPBZ+M9PqdnC8U=";
  };

  patches = [
    ./android-tools-kernel-headers-6.0.diff
  ];

  postPatch = lib.optionalString stdenv.isDarwin ''
    sed -i 's/usb_linux/usb_osx/g' vendor/CMakeLists.{adb,fastboot}.txt
    sed -i 's/libselinux libsepol/ /g;s#selinux/libselinux/include##g' vendor/CMakeLists.{fastboot,mke2fs}.txt
    sed -z -i 's/add_library(libselinux.*selinux\/libsepol\/include)//g' vendor/CMakeLists.fastboot.txt
    sed -i 's/e2fsdroid//g' vendor/CMakeLists.txt
    sed -z -i 's/add_executable(e2fsdroid.*e2fsprogs\/misc)//g' vendor/CMakeLists.mke2fs.txt
  '';

  nativeBuildInputs = [ cmake perl go ];
  buildInputs = [ protobuf zlib gtest brotli lz4 zstd libusb1 pcre2 ];
  propagatedBuildInputs = [ pythonEnv ];

  # Don't try to fetch any Go modules via the network:
  GOFLAGS = [ "-mod=vendor" ];

  NIX_CFLAGS_COMPILE = lib.optionals stdenv.isDarwin [
    "-D_DARWIN_C_SOURCE"
  ];

  NIX_LDFLAGS = lib.optionals stdenv.isDarwin [
    "-framework CoreFoundation"
    "-framework IOKit"
  ];

  preConfigure = ''
    export GOCACHE=$TMPDIR/go-cache
  '';

  postInstall = ''
    install -Dm755 ../vendor/avb/avbtool.py -t $out/bin
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
      - mkbootimg, unpack_bootimg, repack_bootimg
    '';
    # https://developer.android.com/studio/command-line#tools-platform
    # https://developer.android.com/studio/releases/platform-tools
    homepage = "https://github.com/nmeum/android-tools";
    license = with licenses; [ asl20 unicode-dfs-2015 ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ primeos ];
  };
}
