{stdenv, fetchurl, fetchFromGitHub, cmake, luajit, kernel, zlib, ncurses, perl, jsoncpp, libb64, openssl, curl, jq, gcc, fetchpatch}:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "sysdig-${version}";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "draios";
    repo = "sysdig";
    rev = version;
    sha256 = "0xw4in2yb3ynpc8jwl95j92kbyr7fzda3mab8nyxcyld7gshrlvd";
  };

  buildInputs = [
    cmake zlib luajit ncurses perl jsoncpp libb64 openssl curl jq gcc
  ];

  hardeningDisable = [ "pic" ];

  cmakeFlags = [
    "-DUSE_BUNDLED_DEPS=OFF"
    "-DSYSDIG_VERSION=${version}"
  ] ++ optional (kernel == null) "-DBUILD_DRIVER=OFF";

  # needed since luajit-2.1.0-beta3
  NIX_CFLAGS_COMPILE = [
    "-DluaL_reg=luaL_Reg"
    "-DluaL_getn(L,i)=((int)lua_objlen(L,i))"
  ];

  postPatch = ''
    sed 's|curl/curlbuild\.h|curl/system.h|' -i \
        userspace/libsinsp/marathon_http.cpp \
        userspace/libsinsp/mesos_http.cpp
 '';

  preConfigure = ''
    export INSTALL_MOD_PATH="$out"
  '' + optionalString (kernel != null) ''
    export KERNELDIR="${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  '';

  libPath = makeLibraryPath [
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

  postInstall = optionalString (!stdenv.isDarwin) ''
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

  meta = {
    description = "A tracepoint-based system tracing tool for Linux (with clients for other OSes)";
    license = licenses.gpl2;
    maintainers = [maintainers.raskin];
    platforms = platforms.linux ++ platforms.darwin;
    downloadPage = "https://github.com/draios/sysdig/releases";
  };
}
