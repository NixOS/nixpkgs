{ lib, stdenv, fetchFromGitLab, kernel }:

stdenv.mkDerivation rec {
  pname = "librem-ec-acpi-dkms";
  version = "0.9.1-${kernel.version}";

  src = fetchFromGitLab {
    domain = "source.puri.sm";
    owner = "nicole.faerber";
    repo = "librem-ec-acpi-dkms";
    rev = "9be1cc47fbe245f84adb5979c61ce74ae7f68b83";
    sha256 = "1qnbfj60i8nn2ahgj2zp5ixd79bb0wl1ld36x3igws2f3c0f5pfi";
  };

  hardeningDisable = [ "pic" ];

  KERNEL_DIR = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";
  INSTALL_MOD_PATH = placeholder "out";

  nativeBuildInputs = kernel.moduleBuildDependencies;

  buildFlags = [ "all" ];

  installFlags = [ "DEPMOD=true" ];
  enableParallelBuilding = true;

  patches = [
    ./librem-ec-acpi-dkms.patch
  ];

  meta = with lib; {
    homepage = "https://source.puri.sm/nicole.faerber/librem-ec-acpi-dkms";
    maintainers = [ maintainers.avieth ];
    license = lib.licenses.gpl2;
    description = "Kernel module for the Purism Librem EC ACPI DKMS";
    platforms = platforms.linux;
  };
}
