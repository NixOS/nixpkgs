{
  lib,
  stdenv,
  fetchFromGitLab,
  kernel,
}:

let
  version = "0.9.2";
in
stdenv.mkDerivation {
  pname = "librem-ec-acpi";
  version = "${version}-${kernel.version}";

  src = fetchFromGitLab {
    domain = "source.puri.sm";
    owner = "nicole.faerber";
    repo = "librem-ec-acpi-dkms";
    rev = "v${version}";
    sha256 = "gPb1/4UPbwjJiqtP27KKjiIKxIYEl2nlQACUAlxVEFU=";
  };

  hardeningDisable = [ "pic" ];

  KERNEL_DIR = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";
  INSTALL_MOD_PATH = placeholder "out";

  nativeBuildInputs = kernel.moduleBuildDependencies;

  installFlags = [ "DEPMOD=true" ];
  enableParallelBuilding = true;

  patches = [
    # Required to drop assumption of location of module build directory
    # and ensure installation of compiled module:
    ./Makefile.patch
    # Required to make it work on newer Linux versions, as per
    # https://source.puri.sm/nicole.faerber/librem-ec-acpi-dkms/-/merge_requests/2
    ./linux-6.10.3.patch
  ];

  meta = with lib; {
    homepage = "https://source.puri.sm/nicole.faerber/librem-ec-acpi-dkms";
    maintainers = [ maintainers.sjamaan ];
    license = lib.licenses.gpl2Only;
    description = "Kernel module for the Purism Librem EC ACPI DKMS";
    platforms = [ "x86_64-linux" ];
  };
}
