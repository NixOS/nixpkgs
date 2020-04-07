{ stdenv, fetchFromGitHub, fetchpatch, cmake, kernel
, luajit, zlib, ncurses, perl, jsoncpp, libb64, openssl, curl, jq, gcc, elfutils, tbb, c-ares, protobuf, grpc
}:

with stdenv.lib;
stdenv.mkDerivation rec {
  pname = "sysdig";
  version = "0.26.6";

  src = fetchFromGitHub {
    owner = "draios";
    repo = "sysdig";
    rev = version;
    sha256 = "1rw9s5lamr02036z26vfmnp5dnn97f00hcnp4xv6gdxim6rpmbz7";
  };

  nativeBuildInputs = [ cmake perl ];
  buildInputs = [
    zlib luajit ncurses jsoncpp libb64 openssl curl jq gcc elfutils tbb c-ares protobuf grpc
  ] ++ optionals (kernel != null) kernel.moduleBuildDependencies;

  hardeningDisable = [ "pic" ];

  cmakeFlags = [
    "-DUSE_BUNDLED_DEPS=OFF"
    "-DSYSDIG_VERSION=${version}"
    "-DCREATE_TEST_TARGETS=OFF"
  ] ++ optional (kernel == null) "-DBUILD_DRIVER=OFF";

  NIX_CFLAGS_COMPILE = toString [
    "-ltbb -lcurl"
    # needed since luajit-2.1.0-beta3
    "-DluaL_reg=luaL_Reg -DluaL_getn(L,i)=((int)lua_objlen(L,i))"
  ];

  patches = [
    (fetchpatch {
      url = "https://github.com/Mic92/sysdig/commit/798c43d814c74d7fb955933cda35979e82fb8f92.patch";
      sha256 = "10qky6s924yrvk3n9qvy3sxx1bw7c073rzcj0zq46rwihdgb6bw1";
    })
  ];

  KERNELDIR = stdenv.lib.optionalString (kernel != null)
    "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";
  INSTALL_MOD_PATH = placeholder "out";

  postInstall = optionalString (kernel != null) ''
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
