{
  lib,
  stdenv,
  fetchFromGitLab,
  kernel,
}:

stdenv.mkDerivation rec {
  pname = "librem-ec-acpi";
  version = "0.9.2-${kernel.version}";

  src = fetchFromGitLab {
    domain = "source.puri.sm";
    owner = "nicole.faerber";
    repo = "librem-ec-acpi-dkms";
    rev = "cec8c0e8bf1532c9c605f60bb02a2ef0f98e5d77";
    sha256 = "gPb1/4UPbwjJiqtP27KKjiIKxIYEl2nlQACUAlxVEFU=";
  };

  hardeningDisable = [ "pic" ];

  KERNEL_DIR = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";
  INSTALL_MOD_PATH = placeholder "out";

  nativeBuildInputs = kernel.moduleBuildDependencies;

  buildFlags = [ "all" ];

  installFlags = [ "DEPMOD=true" ];
  enableParallelBuilding = true;

  patches = [ ./Makefile.patch ];

  meta = with lib; {
    homepage = "https://source.puri.sm/nicole.faerber/librem-ec-acpi-dkms";
    maintainers = [ maintainers.sjamaan ];
    license = lib.licenses.gpl2;
    description = "Kernel module for the Purism Librem EC ACPI DKMS";
    platforms = platforms.linux;
  };
}
