{ lib, fetchFromGitHub, kernel, buildModule }:
let
  version = "1.0.2";
  sha256 = "1i7zjn5cdv9h00fgjg46b8yrz4d3dqvfr25g3f13967ycy58m48h";
in
buildModule {
  pname = "system76-acpi-module";
  inherit version;

  passthru.moduleName = "system76_acpi";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "system76-acpi-dkms";
    rev = version;
    inherit sha256;
  };

  hardeningDisable = [ "pic" ];

  buildFlags = [
    "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  installPhase = ''
    install -D system76_acpi.ko $out/lib/modules/${kernel.modDirVersion}/misc/system76_acpi.ko
    mkdir -p $out/lib/udev/hwdb.d
    mv lib/udev/hwdb.d/* $out/lib/udev/hwdb.d
  '';

  overridePlatforms = [ "i686-linux" "x86_64-linux" ];

  meta = with lib; {
    maintainers = [ maintainers.khumba ];
    license = [ licenses.gpl2Only ];
    broken = kernel.kernelOlder "5.2";
    description = "System76 ACPI Driver (DKMS)";
    homepage = "https://github.com/pop-os/system76-acpi-dkms";
    longDescription = ''
      This provides the system76_acpi in-tree driver for systems missing it.
    '';
  };
}
