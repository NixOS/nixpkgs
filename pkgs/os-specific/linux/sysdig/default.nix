{ lib, stdenv, fetchFromGitHub, fetchpatch, cmake, kernel, installShellFiles, pkg-config
, luajit, ncurses, perl, jsoncpp, libb64, openssl, curl, jq, gcc, elfutils, tbb, protobuf, grpc
, libyamlcpp, nlohmann_json
}:

with lib;
let
  # Compare with https://github.com/draios/sysdig/blob/dev/cmake/modules/falcosecurity-libs.cmake
  libsRev = "e5c53d648f3c4694385bbe488e7d47eaa36c229a";
  libsSha256 = "sha256-pG10y5PpDqaF/cq8oAvax5B/ls2UTRQd7tCfBjWVf0U=";

  # Compare with https://github.com/falcosecurity/libs/blob/master/cmake/modules/valijson.cmake#L17
  valijson = fetchFromGitHub {
    owner = "tristanpenman";
    repo = "valijson";
    rev = "v0.6";
    sha256 = "sha256-ZD19Q2MxMQd3yEKbY90GFCrerie5/jzgO8do4JQDoKM=";
  };

in
stdenv.mkDerivation rec {
  pname = "sysdig";
  version = "0.29.3";

  src = fetchFromGitHub {
    owner = "draios";
    repo = "sysdig";
    rev = version;
    sha256 = "sha256-dMLeroOd9CgvmgQdPfX8oBxQSyksZi/hP4vO03JhlF0=";
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
    protobuf
    grpc
    libyamlcpp
    jsoncpp
    nlohmann_json
  ] ++ optionals (kernel != null) kernel.moduleBuildDependencies;

  hardeningDisable = [ "pic" ];

  postUnpack = ''
    cp -r ${fetchFromGitHub {
      owner = "falcosecurity";
      repo = "libs";
      rev = libsRev;
      sha256 = libsSha256;
    }} libs
    chmod -R +w libs
    cmakeFlagsArray+=("-DFALCOSECURITY_LIBS_SOURCE_DIR=$(pwd)/libs" "-DVALIJSON_INCLUDE=${valijson}/include")
  '';

  cmakeFlags = [
    "-DUSE_BUNDLED_DEPS=OFF"
    "-DSYSDIG_VERSION=${version}"
    "-DCREATE_TEST_TARGETS=OFF"
  ] ++ optional (kernel == null) "-DBUILD_DRIVER=OFF";

  # needed since luajit-2.1.0-beta3
  NIX_CFLAGS_COMPILE = "-DluaL_reg=luaL_Reg -DluaL_getn(L,i)=((int)lua_objlen(L,i))";

  preConfigure = ''
    if ! grep -q "${libsRev}" cmake/modules/falcosecurity-libs.cmake; then
      echo "falcosecurity-libs checksum needs to be updated!"
      exit 1
    fi
    cmakeFlagsArray+=(-DCMAKE_EXE_LINKER_FLAGS="-ltbb -lcurl -labsl_synchronization")
  '' + optionalString (kernel != null) ''
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
    + optionalString (kernel != null) ''
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


  meta = {
    description = "A tracepoint-based system tracing tool for Linux (with clients for other OSes)";
    license = with licenses; [ asl20 gpl2 mit ];
    maintainers = [maintainers.raskin];
    platforms = ["x86_64-linux"] ++ platforms.darwin;
    broken = kernel != null && versionOlder kernel.version "4.14";
    homepage = "https://sysdig.com/opensource/";
    downloadPage = "https://github.com/draios/sysdig/releases";
  };
}
