{stdenv, fetchurl, cmake, luajit, kernel, zlib, ncurses}:
let
  inherit (stdenv.lib) optional optionalString;
  s = rec {
    baseName="sysdig";
    version = "0.2.0";
    name="${baseName}-${version}";
    url="https://github.com/draios/sysdig/archive/${version}.tar.gz";
    sha256 = "1si156i0ny7jk536c6jfvaivhss3nn0f1ka9f4bqzsgrjjgy1bgg";
  };
  buildInputs = [
    cmake zlib luajit ncurses
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
    "-DUSE_BUNDLED_NCURSES=OFF"
  ] ++ optional (kernel == null) "-DBUILD_DRIVER=OFF";
  preConfigure = ''
    export INSTALL_MOD_PATH="$out"
  '' + optionalString (kernel != null) ''
    export KERNELDIR="${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  '';
  postInstall = optionalString (kernel != null) ''
    make install_driver
    kernel_dev=${kernel.dev}
    kernel_dev=''${kernel_dev#/nix/store/}
    kernel_dev=''${kernel_dev%%-linux*dev*}
    sed -i "s#$kernel_dev#................................#g" $out/lib/modules/${kernel.modDirVersion}/extra/sysdig-probe.ko
  '';

  meta = with stdenv.lib; {
    inherit (s) version;
    description = ''A tracepoint-based system tracing tool for Linux (with clients for other OSes)'';
    license = licenses.gpl2;
    maintainers = with maintainers; [raskin offline];
    platforms = platforms.linux ++ platforms.darwin;
    downloadPage = "https://github.com/draios/sysdig/releases";
  };
}
