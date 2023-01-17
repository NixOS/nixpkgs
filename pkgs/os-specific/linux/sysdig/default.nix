{ lib, stdenv, fetchFromGitHub, fetchpatch, cmake, kernel, installShellFiles, pkg-config
, luajit, ncurses, perl, jsoncpp, libb64, openssl, curl, jq, gcc, elfutils, tbb, protobuf, grpc
, libyamlcpp, nlohmann_json, re2
}:

let
  # Compare with https://github.com/draios/sysdig/blob/dev/cmake/modules/falcosecurity-libs.cmake
  libsRev = "0.9.1";
  libsSha256 = "sha256-X+zLEnage8AuGdGn9sl1RN9b1CKTA1ErrdPNbYKY0s0=";

  # Compare with https://github.com/falcosecurity/libs/blob/master/cmake/modules/valijson.cmake#L17
  valijson = fetchFromGitHub {
    owner = "tristanpenman";
    repo = "valijson";
    rev = "v0.6";
    sha256 = "sha256-ZD19Q2MxMQd3yEKbY90GFCrerie5/jzgO8do4JQDoKM=";
  };

  driver = fetchFromGitHub {
    owner = "falcosecurity";
    repo = "libs";
    rev = "3.0.1+driver";
    sha256 = "sha256-bK9wv17bVl93rOqw7JICnMOM0fDtPIErfMmUmNKOD5c=";
  };

in
stdenv.mkDerivation rec {
  pname = "sysdig";
  version = "0.30.2";

  src = fetchFromGitHub {
    owner = "draios";
    repo = "sysdig";
    rev = version;
    sha256 = "sha256-bDlrnTfm43zpYBIiP2MGB+LM5jtalmeUNtWHgxe81HM=";
  };

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
    libyamlcpp
    jsoncpp
    nlohmann_json
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

  # needed since luajit-2.1.0-beta3
  NIX_CFLAGS_COMPILE = "-DluaL_reg=luaL_Reg -DluaL_getn(L,i)=((int)lua_objlen(L,i))";

  preConfigure = ''
    if ! grep -q "${libsRev}" cmake/modules/falcosecurity-libs.cmake; then
      echo "falcosecurity-libs checksum needs to be updated!"
      exit 1
    fi
    cmakeFlagsArray+=(-DCMAKE_EXE_LINKER_FLAGS="-ltbb -lcurl -labsl_synchronization")
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
      kernel_dev=''${kernel_dev#/nix/store/}
      kernel_dev=''${kernel_dev%%-linux*dev*}
      if test -f "$out/lib/modules/${kernel.modDirVersion}/extra/scap.ko"; then
          sed -i "s#$kernel_dev#................................#g" $out/lib/modules/${kernel.modDirVersion}/extra/scap.ko
      else
          xz -d $out/lib/modules/${kernel.modDirVersion}/extra/scap.ko.xz
          sed -i "s#$kernel_dev#................................#g" $out/lib/modules/${kernel.modDirVersion}/extra/scap.ko
          xz $out/lib/modules/${kernel.modDirVersion}/extra/scap.ko
      fi
    '';


  meta = with lib; {
    description = "A tracepoint-based system tracing tool for Linux (with clients for other OSes)";
    license = with licenses; [ asl20 gpl2 mit ];
    maintainers = [maintainers.raskin];
    platforms = ["x86_64-linux"] ++ platforms.darwin;
    broken = kernel != null && lib.versionOlder kernel.version "4.14";
    homepage = "https://sysdig.com/opensource/";
    downloadPage = "https://github.com/draios/sysdig/releases";
  };
}
