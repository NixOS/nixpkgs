{stdenv, fetchurl, cmake, luajit, kernel, zlib}:
let
  s = rec {
    baseName="sysdig";
    version="0.1.81";
    name="${baseName}-${version}";
    url="https://github.com/draios/sysdig/archive/${version}.tar.gz";
    sha256="0p9j1fy7lr027nsvr5bq0416nlsbvk02irzazmigsbr03fg0x1wv";
  };
  buildInputs = [
    cmake luajit kernel zlib
  ];
in
stdenv.mkDerivation {
  inherit (s) name version;
  inherit buildInputs;
  src = fetchurl {
    inherit (s) url sha256;
  };

  cmakeFlags = [
    "-DUSE_BUNDLED_LUAJIT=OFF"
    "-DUSE_BUNDLED_ZLIB=OFF"
  ];
  preConfigure = ''
    export INSTALL_MOD_PATH="$out"
    export KERNELDIR="${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  '';
  postInstall = ''
    make install_driver
  '';

  meta = {
    inherit (s) version;
    description = ''A tracepoint-based system tracing tool for Linux'';
    license = stdenv.lib.licenses.gpl2 ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
