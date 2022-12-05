{ lib, stdenv, fetchurl, fetchpatch
, cmake, pkg-config, perl, go, python3
, protobuf, zlib, gtest, brotli, lz4, zstd, libusb1, pcre2
}:

let
  pythonEnv = python3.withPackages(ps: [ ps.protobuf ]);
in

stdenv.mkDerivation rec {
  pname = "android-tools";
  version = "33.0.3p1";

  src = fetchurl {
    url = "https://github.com/nmeum/android-tools/releases/download/${version}/android-tools-${version}.tar.xz";
    hash = "sha256-viBHzyVgUWdK9a60u/7SdpiVEvgNEZHihkyRkGH5Ydg=";
  };

  patches = [
    (fetchpatch {
      name = "add-macos-platform.patch";
      url = "https://github.com/nmeum/android-tools/commit/a1ab35b31525966e0f0770047cd82accb36d025b.patch";
      hash = "sha256-6O3ekDf0qPdzcfINFF8Ae4XOYgnQWTBhvu9SCFSHkXY=";
    })
  ];

  nativeBuildInputs = [ cmake pkg-config perl go ];
  buildInputs = [ protobuf zlib gtest brotli lz4 zstd libusb1 pcre2 ];
  propagatedBuildInputs = [ pythonEnv ];

  # Don't try to fetch any Go modules via the network:
  GOFLAGS = [ "-mod=vendor" ];

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
