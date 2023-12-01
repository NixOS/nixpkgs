{ lib, stdenv, fetchFromGitHub, cmake, kernel, installShellFiles, pkg-config
, luajit, ncurses, perl, jsoncpp, openssl, curl, jq, gcc, elfutils, tbb, protobuf, grpc
, yaml-cpp, nlohmann_json, re2, zstd, uthash, fetchpatch, fetchurl
}:

let
  # Compare with https://github.com/draios/sysdig/blob/dev/cmake/modules/falcosecurity-libs.cmake
  libsRev = "0.13.1";
  libsHash = "sha256-UNoXIkFr64Nr0XVAtV4+BMNpCk4w8Dn4waZek/ok4Uk=";

  # Compare with https://github.com/falcosecurity/libs/blob/master/cmake/modules/valijson.cmake#L17
  valijson = fetchFromGitHub {
    owner = "tristanpenman";
    repo = "valijson";
    rev = "v0.6";
    hash = "sha256-ZD19Q2MxMQd3yEKbY90GFCrerie5/jzgO8do4JQDoKM=";
  };

  tinydir = fetchFromGitHub {
    owner = "cxong";
    repo = "tinydir";
    rev = "1.2.5";
    hash = "sha256-qQhvLzpCYMAafBNRWlY5yklHrILM8BYD+xxF0l17+do=";
  };

  # https://github.com/draios/sysdig/blob/0.31.5/cmake/modules/driver.cmake
  driver = fetchFromGitHub {
    owner = "falcosecurity";
    repo = "libs";
    rev = "6.0.1+driver";
    hash = "sha256-e9TJl/IahrUc4Yq2/KssTz3IBjOZwXeLt1jOkZ94EiE=";
  };

  # can be dropped in next release
  uthashDevendorPatch = fetchpatch {
    url = "https://github.com/falcosecurity/libs/commit/0d58f798ab72e21a16ee6965c775cba2932e5100.patch";
    hash = "sha256-5Y79M9u5rXZiKllJcXzDDw/3JKt0k/CgvWx+MZepkpw=";
  };

  # https://github.com/falcosecurity/libs/blob/master/cmake/modules/b64.cmake
  base64 = fetchurl {
    url = "https://raw.githubusercontent.com/istio/proxy/1.18.2/extensions/common/wasm/base64.h";
    hash = "sha256-WvHRHp5caMBDvH+2pMrU4ZptX6WvPcPaeVGtVBBCw64=";
  };
in
stdenv.mkDerivation rec {
  pname = "sysdig";
  version = "0.34.1";

  src = fetchFromGitHub {
    owner = "draios";
    repo = "sysdig";
    rev = version;
    hash = "sha256-G1yr1wHiaGvLMtBZgh4eoiRNJiH0cghHqWFOjKYXXsw=";
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
    cp -r ${fetchFromGitHub {
      owner = "falcosecurity";
      repo = "libs";
      rev = libsRev;
      hash = libsHash;
    }} libs
    chmod -R +w libs
    pushd libs
    patch -p1 < ${uthashDevendorPatch}
    popd

    cp -r ${driver} driver-src
    chmod -R +w driver-src
    pushd driver-src
    patch -p1 < ${uthashDevendorPatch}
    popd
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
    "-DTINYDIR_INCLUDE=${tinydir}"
    "-DUTHASH_INCLUDE=${uthash}/include"
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
    install -D ${base64} build/b64/base64.h
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
