{ lib, stdenv, fetchFromGitHub, kernel }:

stdenv.mkDerivation rec {
  name = "it87-${version}-${kernel.version}";
  version = "unstable-2022-02-26";

  # Original is no longer maintained.
  # This is the same upstream as the AUR uses.
  src = fetchFromGitHub {
    owner = "frankcrawford";
    repo = "it87";
    rev = "c93d61adadecb009c92f3258cd3ff14a66efb193";
    sha256 = "sha256-wVhs//iwZUUGRTk1DpV/SnA7NZ7cFyYbsUbtazlxb6Q=";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  preConfigure = ''
    sed -i 's|depmod|#depmod|' Makefile
  '';

  makeFlags = [
    "TARGET=${kernel.modDirVersion}"
    "KERNEL_MODULES=${kernel.dev}/lib/modules/${kernel.modDirVersion}"
    "MODDESTDIR=$(out)/lib/modules/${kernel.modDirVersion}/kernel/drivers/hwmon"
  ];

  meta = with lib; {
    description = "Patched module for IT87xx superio chip sensors support";
    homepage = "https://github.com/hannesha/it87";
    license = licenses.gpl2Plus;
    platforms = [ "x86_64-linux" "i686-linux" ];
    maintainers = teams.lumiguide.members;
  };
}
