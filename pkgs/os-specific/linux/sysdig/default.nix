{ lib, stdenv, fetchFromGitHub, cmake, kernel, installShellFiles
, luajit, ncurses, perl, jsoncpp, libb64, openssl, curl, jq, gcc, elfutils, tbb, protobuf, grpc
}:

with lib;
stdenv.mkDerivation rec {
  pname = "sysdig";
  version = "0.27.1";

  src = fetchFromGitHub {
    owner = "draios";
    repo = "sysdig";
    rev = version;
    sha256 = "sha256-lYjMvxMIReANNwMr62u881Nugrs9piOaN3EmrvGzRns=";
  };

  nativeBuildInputs = [ cmake perl installShellFiles ];
  buildInputs = [
    luajit ncurses jsoncpp libb64 openssl curl jq gcc elfutils tbb protobuf grpc
  ] ++ optionals (kernel != null) kernel.moduleBuildDependencies;

  hardeningDisable = [ "pic" ];

  cmakeFlags = [
    "-DUSE_BUNDLED_DEPS=OFF"
    "-DSYSDIG_VERSION=${version}"
    "-DCREATE_TEST_TARGETS=OFF"
  ] ++ optional (kernel == null) "-DBUILD_DRIVER=OFF";

  # needed since luajit-2.1.0-beta3
  NIX_CFLAGS_COMPILE = "-DluaL_reg=luaL_Reg -DluaL_getn(L,i)=((int)lua_objlen(L,i))";

  preConfigure = ''
    cmakeFlagsArray+=(-DCMAKE_EXE_LINKER_FLAGS="-ltbb -lcurl -labsl_synchronization")

    export INSTALL_MOD_PATH="$out"
  '' + optionalString (kernel != null) ''
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
      if test -f "$out/lib/modules/${kernel.modDirVersion}/extra/sysdig-probe.ko"; then
          sed -i "s#$kernel_dev#................................#g" $out/lib/modules/${kernel.modDirVersion}/extra/sysdig-probe.ko
      else
          xz -d $out/lib/modules/${kernel.modDirVersion}/extra/sysdig-probe.ko.xz
          sed -i "s#$kernel_dev#................................#g" $out/lib/modules/${kernel.modDirVersion}/extra/sysdig-probe.ko
          xz $out/lib/modules/${kernel.modDirVersion}/extra/sysdig-probe.ko
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
