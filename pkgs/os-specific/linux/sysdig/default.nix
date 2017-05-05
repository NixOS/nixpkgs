{stdenv, fetchurl, fetchFromGitHub, cmake, luajit, kernel, zlib, ncurses, perl, jsoncpp, libb64, openssl, curl, jq, gcc, fetchpatch}:

let
  inherit (stdenv.lib) optional optionalString;
  baseName = "sysdig";
  version = "0.15.0";
in
stdenv.mkDerivation rec {
  name = "${baseName}-${version}";

  src = fetchurl {
    name = "${name}.tar.gz";
    url = "https://github.com/draios/sysdig/archive/${version}.tar.gz";
    sha256 = "08spprzgx6ksd7sjp5nk7z5szdlixh2sb0bsb9mfaq4xr12gsjw2";
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

  meta = with stdenv.lib; {
    description = "A tracepoint-based system tracing tool for Linux (with clients for other OSes)";
    license = licenses.gpl2;
    maintainers = [maintainers.raskin];
    platforms = platforms.linux ++ platforms.darwin;
    downloadPage = "https://github.com/draios/sysdig/releases";
  };
}
