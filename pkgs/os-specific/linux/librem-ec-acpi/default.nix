{ lib, stdenv, fetchFromGitLab, kernel }:
let
  version = "0.9.1";
in
stdenv.mkDerivation {
  name = "librem-ec-acpi-module-${version}-${kernel.version}";

  passthru.moduleName = "librem_ec_acpi";

  src = fetchFromGitLab {
    domain = "source.puri.sm";
    owner = "nicole.faerber";
    repo = "librem-ec-acpi-dkms";
    rev = "v${version}";
    sha256 = "1qnbfj60i8nn2ahgj2zp5ixd79bb0wl1ld36x3igws2f3c0f5pfi";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  buildFlags = [
    "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  installPhase = ''
    install -D librem_ec_acpi.ko $out/lib/modules/${kernel.modDirVersion}/misc/librem_ec_acpi.ko
  '';

  meta = with lib; {
    license = [ licenses.gpl2Only ];
    platforms = [ "i686-linux" "x86_64-linux" ];
    broken = versionOlder kernel.version "5.13";
    description = "Librem Embedded Controller ACPI Driver (DKMS)";
    homepage = "https://source.puri.sm/nicole.faerber/librem-ec-acpi-dkms";
    longDescription = ''
      This provides the librem_ec_acpi in-tree driver for systems missing it.
    '';
  };
}
