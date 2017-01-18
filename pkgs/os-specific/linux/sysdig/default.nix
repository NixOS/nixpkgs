{stdenv, fetchurl, fetchFromGitHub, cmake, luajit, kernel, zlib, ncurses, perl, jsoncpp, libb64, openssl, curl, jq, gcc, fetchpatch}:
let
  inherit (stdenv.lib) optional optionalString;
  baseName = "sysdig";
  version = "0.13.0";
in
stdenv.mkDerivation {
  name = "${baseName}-${version}";

  src = fetchurl {
    url = "https://github.com/draios/sysdig/archive/${version}.tar.gz";
    sha256 = "0ghxj473v471nnry8h9accxpwwjp8nbzkgw8dniqld0ixx678pia";
  };

  buildInputs = [
    cmake zlib luajit ncurses perl jsoncpp libb64 openssl curl jq gcc
  ];

  hardeningDisable = [ "pic" ];

  patches = [
    # patch for linux >= 4.9.1
    # is included in the next release
    (fetchpatch {
      url = "https://github.com/draios/sysdig/commit/68823ffd3a76f88ad34c3d0d9f6fdf1ada0eae43.patch";
      sha256 = "02vgyd70mwrk6mcdkacaahk49irm6vxzqb7dfickk6k32lh3m44k";
    })
  ];

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
