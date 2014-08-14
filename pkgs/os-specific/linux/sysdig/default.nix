{stdenv, fetchurl, cmake, luajit, kernel, zlib}:
let
  inherit (stdenv.lib) optional optionalString;
  s = rec {
    baseName="sysdig";
    version="0.1.87";
    name="${baseName}-${version}";
    url="https://github.com/draios/sysdig/archive/${version}.tar.gz";
    sha256="0xfildaj8kzbngpza47zqm363i6q87m97a18qlmdisrxmz11s32b";
  };
  buildInputs = [
    cmake zlib luajit
  ] ++ optional (kernel != null) kernel;
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
  ] ++ optional (kernel == null) "-DBUILD_DRIVER=OFF";
  preConfigure = ''
    export INSTALL_MOD_PATH="$out"
  '' + optionalString (kernel != null) ''
    export KERNELDIR="${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  '';
  postInstall = optionalString (kernel != null) ''
    make install_driver
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
