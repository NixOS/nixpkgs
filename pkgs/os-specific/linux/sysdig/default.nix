{stdenv, fetchurl, fetchFromGitHub, cmake, luajit, kernel, zlib, ncurses, perl, jsoncpp, libb64, openssl, curl, jq, gcc}:
let
  inherit (stdenv.lib) optional optionalString;
  baseName = "sysdig";
  version = "0.12.0";
in
stdenv.mkDerivation {
  name = "${baseName}-${version}";

  src = fetchurl {
    url = "https://github.com/draios/sysdig/archive/${version}.tar.gz";
    sha256 = "17nf2h5ajy333rwh91hzaw8zq2mnkb3lxy8fmbbs8qazgsvwz6c3";
  };

  buildInputs = [
    cmake zlib luajit ncurses perl jsoncpp libb64 openssl curl jq gcc
  ];

  hardeningDisable = [ "pic" ];

  postPatch = ''
    sed '1i#include <cmath>' -i userspace/libsinsp/{cursesspectro,filterchecks}.cpp
  '';

  cmakeFlags = [
    "-DUSE_BUNDLED_DEPS=OFF"
    "-DSYSDIG_VERSION=${version}"
  ] ++ optional (kernel == null) "-DBUILD_DRIVER=OFF";

  preConfigure = ''
    export INSTALL_MOD_PATH="$out"
  '' + optionalString (kernel != null) ''
    export KERNELDIR="${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  '';

  libPath = stdenv.lib.makeLibraryPath [
    zlib
    luajit
    ncurses
    jsoncpp
    curl
    jq
    openssl
    libb64
    gcc
    stdenv.cc.cc
  ];

  postInstall = ''
    patchelf --set-rpath "$libPath" "$out/bin/sysdig"
    patchelf --set-rpath "$libPath" "$out/bin/csysdig"
  '' + optionalString (kernel != null) ''
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

  meta = with stdenv.lib; {
    description = "A tracepoint-based system tracing tool for Linux (with clients for other OSes)";
    license = licenses.gpl2;
    maintainers = [maintainers.raskin];
    platforms = platforms.linux ++ platforms.darwin;
    downloadPage = "https://github.com/draios/sysdig/releases";
  };
}
