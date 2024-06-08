{ lib, stdenv, fetchFromGitHub, cmake, kernel, installShellFiles, pkg-config
, luajit, ncurses, perl, jsoncpp, openssl, curl, jq, gcc, elfutils, tbb
, protobuf, grpc, yaml-cpp, nlohmann_json, re2, zstd, uthash }:

let
  # Compare with https://github.com/draios/sysdig/blob/0.37.1/cmake/modules/falcosecurity-libs.cmake
  libsRev = "0.16.0";
  libsHash = "sha256-aduO2pLj91tRdZ1dW1F1JFEg//SopialXWPd6Oav/u8=";

  # Compare with https://github.com/falcosecurity/libs/blob/0.16.0/cmake/modules/valijson.cmake
  valijson = fetchFromGitHub {
    owner = "tristanpenman";
    repo = "valijson";
    rev = "v1.0.2";
    hash = "sha256-wvFdjsDtKH7CpbEpQjzWtLC4RVOU9+D2rSK0Xo1cJqo=";
  };

  # https://github.com/draios/sysdig/blob/0.37.1/cmake/modules/driver.cmake
  driver = fetchFromGitHub {
    owner = "falcosecurity";
    repo = "libs";
    rev = "7.1.0+driver";
    hash = "sha256-FIlnJsNgofGo4HETEEpW28wpC3U9z5AZprwFR5AgFfA=";
  };

  version = "0.37.1";
in stdenv.mkDerivation {
  pname = "sysdig";
  inherit version;

  src = fetchFromGitHub {
    owner = "draios";
    repo = "sysdig";
    rev = version;
    hash = "sha256-V1rvQ6ZznL9UiUFW2lyW6gvdoGttOd5kgT2KPQCjmvQ=";
  };

  nativeBuildInputs = [ cmake perl installShellFiles pkg-config ];
  buildInputs = [
    luajit
    ncurses
    openssl
    curl
    jq
    gcc
    elfutils
    tbb
    re2
    protobuf
    grpc
    yaml-cpp
    jsoncpp
    nlohmann_json
    zstd
    uthash
  ] ++ lib.optionals (kernel != null) kernel.moduleBuildDependencies;

  hardeningDisable = [ "pic" ];

  postUnpack = ''
    cp -r ${
      fetchFromGitHub {
        owner = "falcosecurity";
        repo = "libs";
        rev = libsRev;
        hash = libsHash;
      }
    } libs
    chmod -R +w libs

    substituteInPlace libs/userspace/libscap/libscap.pc.in libs/userspace/libsinsp/libsinsp.pc.in \
      --replace-fail "\''${prefix}/@CMAKE_INSTALL_LIBDIR@" "@CMAKE_INSTALL_FULL_LIBDIR@" \
      --replace-fail "\''${prefix}/@CMAKE_INSTALL_INCLUDEDIR@" "@CMAKE_INSTALL_FULL_INCLUDEDIR@"

    cp -r ${driver} driver-src
    chmod -R +w driver-src

    cmakeFlagsArray+=(
      "-DFALCOSECURITY_LIBS_SOURCE_DIR=$(pwd)/libs"
      "-DDRIVER_SOURCE_DIR=$(pwd)/driver-src/driver"
    )
  '';

  cmakeFlags = [
    "-DUSE_BUNDLED_DEPS=OFF"
    "-DSYSDIG_VERSION=${version}"
    "-DUSE_BUNDLED_B64=OFF"
    "-DUSE_BUNDLED_TBB=OFF"
    "-DUSE_BUNDLED_RE2=OFF"
    "-DUSE_BUNDLED_JSONCPP=OFF"
    "-DCREATE_TEST_TARGETS=OFF"
    "-DVALIJSON_INCLUDE=${valijson}/include"
    "-DUTHASH_INCLUDE=${uthash}/include"
  ] ++ lib.optional (kernel == null) "-DBUILD_DRIVER=OFF";

  env.NIX_CFLAGS_COMPILE =
    # fix compiler warnings been treated as errors
    "-Wno-error";

  preConfigure = ''
    if ! grep -q "${libsRev}" cmake/modules/falcosecurity-libs.cmake; then
      echo "falcosecurity-libs checksum needs to be updated!"
      exit 1
    fi
    cmakeFlagsArray+=(-DCMAKE_EXE_LINKER_FLAGS="-ltbb -lcurl -lzstd -labsl_synchronization")
  '' + lib.optionalString (kernel != null) ''
    export INSTALL_MOD_PATH="$out"
    export KERNELDIR="${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  '';

  postInstall = ''
    # Fix the bash completion location
    installShellCompletion --bash $out/etc/bash_completion.d/sysdig
    rm $out/etc/bash_completion.d/sysdig
    rmdir $out/etc/bash_completion.d
    rmdir $out/etc
  '' + lib.optionalString (kernel != null) ''
    make install_driver
    kernel_dev=${kernel.dev}
    kernel_dev=''${kernel_dev#${builtins.storeDir}/}
    kernel_dev=''${kernel_dev%%-linux*dev*}
    if test -f "$out/lib/modules/${kernel.modDirVersion}/extra/scap.ko"; then
        sed -i "s#$kernel_dev#................................#g" $out/lib/modules/${kernel.modDirVersion}/extra/scap.ko
    else
        for i in $out/lib/modules/${kernel.modDirVersion}/{extra,updates}/scap.ko.xz; do
          if test -f "$i"; then
            xz -d $i
            sed -i "s#$kernel_dev#................................#g" ''${i%.xz}
            xz -9 ''${i%.xz}
          fi
        done
    fi
  '';

  meta = {
    description =
      "A tracepoint-based system tracing tool for Linux (with clients for other OSes)";
    license = with lib.licenses; [ asl20 gpl2 mit ];
    maintainers = with lib.maintainers; [ raskin ];
    platforms = [ "x86_64-linux" ] ++ lib.platforms.darwin;
    broken = kernel != null && ((lib.versionOlder kernel.version "4.14") || kernel.isHardened || kernel.isZen);
    homepage = "https://sysdig.com/opensource/";
    downloadPage = "https://github.com/draios/sysdig/releases";
  };
}
