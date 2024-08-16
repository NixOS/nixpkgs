{ lib, stdenv, fetchurl, kernel }:

assert lib.versionOlder kernel.version "4.10";

stdenv.mkDerivation rec {
  name = "e1000e-${version}-${kernel.version}";
  version = "3.8.4";

  src = fetchurl {
    url = "mirror://sourceforge/e1000/e1000e-${version}.tar.gz";
    sha256 = "1q8dbqh14c7r15q6k6iv5k0d6xpi74i71d5r54py60gr099m2ha4";
  };

  hardeningDisable = [ "pic" ];

  configurePhase = ''
    cd src
    kernel_version=${kernel.modDirVersion}
    substituteInPlace common.mk \
      --replace "/lib/modules" "${kernel.dev}/lib/modules"
    export makeFlags="BUILD_KERNEL=$kernel_version"
  '';

  installPhase = ''
    install -v -D -m 644 e1000e.ko "$out/lib/modules/$kernel_version/kernel/drivers/net/e1000e/e1000e.ko"
  '';

  dontStrip = true;

  enableParallelBuilding = true;

  meta = {
    description = "Linux kernel drivers for Intel Ethernet adapters and LOMs (LAN On Motherboard)";
    homepage = "http://e1000.sf.net/";
    license = lib.licenses.gpl2Only;
  };
}
