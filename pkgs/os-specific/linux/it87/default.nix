{ lib, stdenv, fetchFromGitHub, kernel }:

stdenv.mkDerivation rec {
  name = "it87-${version}-${kernel.version}";
  version = "unstable-2023-01-28";

  src = fetchFromGitHub {
    owner = "frankcrawford";
    repo = "it87";
    sha256 = "sha256-YIdr9NQuwv6LE0MXtVp+cSOz60w2c+br9mLqMIrGuAc=";
    rev = "49975da600368d57333a0b7e44301a578590b1d3";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  preConfigure = ''
    sed -i -e 's|depmod|#depmod|' Makefile
  '' + lib.optionalString (kernel.kernelOlder "5") ''
    sed -i -e '/^[[:space:]]*fallthrough;/s|^|//|' it87.c
  '';

  makeFlags = [
    "TARGET=${kernel.modDirVersion}"
    "KERNEL_MODULES=${kernel.dev}/lib/modules/${kernel.modDirVersion}"
    "MODDESTDIR=$(out)/lib/modules/${kernel.modDirVersion}/updates/drivers/hwmon"
    "COMPRESS_XZ=y"
  ];

  meta = with lib; {
    description = "Patched module for IT87xx superio chip sensors support";
    homepage = "https://github.com/frankcrawford/it87";
    license = licenses.gpl2Plus;
    platforms = [ "x86_64-linux" "i686-linux" ];
    maintainers = teams.lumiguide.members;
  };
}
