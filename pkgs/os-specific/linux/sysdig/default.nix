{stdenv, fetchurl, fetchFromGitHub, cmake, luajit, kernel, zlib, ncurses, perl, jsoncpp, libb64, openssl, curl}:
let
  inherit (stdenv.lib) optional optionalString;
  s = rec {
    name = "sysdig-${version}";
    version = "0.11.0";
    owner = "draios";
    repo = "sysdig";
    rev = version;
    sha256 = "131bafa7jy16r2jwph50j0bxwqdvr319fsfhqkavx6xy18i31q3v";
  };
  buildInputs = [
    cmake zlib luajit ncurses perl jsoncpp libb64 openssl curl
  ];
  # sysdig-0.11.0 depends on some headers from jq which are not
  # installed by default.
  # Relevant sysdig issue: https://github.com/draios/sysdig/issues/626
  jq-prefix = fetchurl {
    url="https://github.com/stedolan/jq/releases/download/jq-1.5/jq-1.5.tar.gz";
    sha256="0g29kyz4ykasdcrb0zmbrp2jqs9kv1wz9swx849i2d1ncknbzln4";
  };
in
stdenv.mkDerivation {
  inherit (s) name version;
  inherit buildInputs;
  src = fetchFromGitHub {
    inherit (s) owner repo rev sha256;
  };
  postPatch = ''
    sed '1i#include <cmath>' -i userspace/libsinsp/{cursesspectro,filterchecks}.cpp
  '';

  cmakeFlags = [
    "-DUSE_BUNDLED_DEPS=OFF"
    "-DUSE_BUNDLED_JQ=ON"
    "-DSYSDIG_VERSION=${s.version}"
  ] ++ optional (kernel == null) "-DBUILD_DRIVER=OFF";
  preConfigure = ''
    export INSTALL_MOD_PATH="$out"
  '' + optionalString (kernel != null) ''
    export KERNELDIR="${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  '';
  preBuild = ''
    mkdir -p jq-prefix/src
    cp ${jq-prefix} jq-prefix/src/jq-1.5.tar.gz
  '';
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

  meta = with stdenv.lib; {
    inherit (s) version;
    description = ''A tracepoint-based system tracing tool for Linux (with clients for other OSes)'';
    license = licenses.gpl2;
    maintainers = [maintainers.raskin];
    platforms = platforms.linux ++ platforms.darwin;
    downloadPage = "https://github.com/draios/sysdig/releases";
  };
}
