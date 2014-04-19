{stdenv, fetchurl, cmake, luajit, kernel}:
let
  s = # Generated upstream information
  rec {
    baseName="sysdig";
    version="0.1.79";
    name="${baseName}-${version}";
    hash="04ng4q859xxlpsnavx6rcgmq7frzgbzxm0p5zmdsmhz8m6hfvz7l";
    url="https://github.com/draios/sysdig/archive/0.1.79.tar.gz";
    sha256="04ng4q859xxlpsnavx6rcgmq7frzgbzxm0p5zmdsmhz8m6hfvz7l";
  };
  buildInputs = [
    cmake luajit kernel
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
  ];
  makeFlags = [
    "KERNELDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];
  postInstall = ''
    mkdir -p $out/lib/modules/${kernel.modDirVersion}/misc/sysdig
    cp driver/*.ko $out/lib/modules/${kernel.modDirVersion}/misc/sysdig
  '';

  meta = {
    inherit (s) version;
    description = ''A tracepoint-based system tracing tool for Linux'';
    license = stdenv.lib.licenses.gpl2 ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
