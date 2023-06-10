{ lib, stdenv, fetchFromGitHub, fetchpatch, cmake, kernel, installShellFiles, pkg-config
, luajit, ncurses, perl, jsoncpp, libb64, openssl, curl, jq, gcc, elfutils, tbb, protobuf, grpc
, yaml-cpp, nlohmann_json, re2, zstd
}:

let
  # Compare with https://github.com/draios/sysdig/blob/dev/cmake/modules/falcosecurity-libs.cmake
  libsRev = "0.11.0";
  libsSha256 = "sha256-QvRTz3yMS6i+qdiSG51wvho9D7w/dMQhY72OYd3qOgU=";

  # Compare with https://github.com/falcosecurity/libs/blob/master/cmake/modules/valijson.cmake#L17
  valijson = fetchFromGitHub {
    owner = "tristanpenman";
    repo = "valijson";
    rev = "v0.6";
    sha256 = "sha256-ZD19Q2MxMQd3yEKbY90GFCrerie5/jzgO8do4JQDoKM=";
  };

  # https://github.com/draios/sysdig/blob/0.31.5/cmake/modules/driver.cmake
  driver = fetchFromGitHub {
    owner = "falcosecurity";
    repo = "libs";
    rev = "5.0.1+driver";
    sha256 = "sha256-CQ6QTcyTnThpJHDXgOM1Zdp5SG7rngp9XtEM+2mS8ro=";
  };

in
stdenv.mkDerivation rec {
  pname = "sysdig";
  version = "0.31.5";

  src = fetchFromGitHub {
    owner = "draios";
    repo = "sysdig";
    rev = version;
    sha256 = "sha256-RuoPqVulATtn7jSga/8fECs7weNfjt/YFh7iHmfCKjw=";
  };

  # to fix the build against the latest kernel
  patches = [
    (fetchpatch {
      url = "https://github.com/draios/sysdig/compare/35ded9aab87801281e22898242e24e0bc63873b2...954e6fc6238f21d4870a491395d68a7dd3062aa9.patch";
      sha256 = "sha256-gnLURnv8FW5LvqjbreCf9DPGdBcn7rfizGeznFqJ+Fk=";
    })
  ];

  nativeBuildInputs = [ cmake perl installShellFiles pkg-config ];
  buildInputs = [
    luajit
    ncurses
    libb64
    openssl
    curl
    jq
    gcc
    elfutils
    tbb
    libb64
    re2
    protobuf
    grpc
    yaml-cpp
    jsoncpp
    nlohmann_json
    zstd
  ] ++ lib.optionals (kernel != null) kernel.moduleBuildDependencies;

  hardeningDisable = [ "pic" ];

  postUnpack = ''
    cp -r ${fetchFromGitHub {
      owner = "falcosecurity";
      repo = "libs";
      rev = libsRev;
      sha256 = libsSha256;
    }} libs
    chmod -R +w libs
    cp -r ${driver} driver-src
    chmod -R +w driver-src
    cmakeFlagsArray+=(
      "-DFALCOSECURITY_LIBS_SOURCE_DIR=$(pwd)/libs"
      "-DVALIJSON_INCLUDE=${valijson}/include"
      "-DDRIVER_SOURCE_DIR=$(pwd)/driver-src/driver"
    )
  '';

  cmakeFlags = [
    "-DUSE_BUNDLED_DEPS=OFF"
    "-DSYSDIG_VERSION=${version}"
    "-DUSE_BUNDLED_B64=OFF"
    "-DUSE_BUNDLED_TBB=OFF"
    "-DUSE_BUNDLED_RE2=OFF"
    "-DCREATE_TEST_TARGETS=OFF"
  ] ++ lib.optional (kernel == null) "-DBUILD_DRIVER=OFF";

  env.NIX_CFLAGS_COMPILE =
   # needed since luajit-2.1.0-beta3
   "-DluaL_reg=luaL_Reg -DluaL_getn(L,i)=((int)lua_objlen(L,i)) " +
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

  postInstall =
    ''
      # Fix the bash completion location
      installShellCompletion --bash $out/etc/bash_completion.d/sysdig
      rm $out/etc/bash_completion.d/sysdig
      rmdir $out/etc/bash_completion.d
      rmdir $out/etc
    ''
    + lib.optionalString (kernel != null) ''
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


  meta = with lib; {
    description = "A tracepoint-based system tracing tool for Linux (with clients for other OSes)";
    license = with licenses; [ asl20 gpl2 mit ];
    maintainers = [maintainers.raskin];
    platforms = ["x86_64-linux"] ++ platforms.darwin;
    broken = kernel != null && versionOlder kernel.version "4.14";
    homepage = "https://sysdig.com/opensource/";
    downloadPage = "https://github.com/draios/sysdig/releases";
  };
}
