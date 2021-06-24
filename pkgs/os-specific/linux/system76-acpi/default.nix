{ lib, stdenv, fetchFromGitHub, kernel }:
let
  version = "1.0.1";
  sha256 = "0jmm9h607f7k20yassm6af9mh5l00yih5248wwv4i05bd68yw3p5";
in
stdenv.mkDerivation {
  name = "system76-acpi-module-${version}-${kernel.version}";

  passthru.moduleName = "system76_acpi";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "system76-acpi-dkms";
    rev = version;
    inherit sha256;
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  buildFlags = [
    "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  installPhase = ''
    install -D system76_acpi.ko $out/lib/modules/${kernel.modDirVersion}/misc/system76_acpi.ko
    mkdir -p $out/lib/udev/hwdb.d
    mv lib/udev/hwdb.d/* $out/lib/udev/hwdb.d
  '';

  meta = with lib; {
    maintainers = [ maintainers.khumba ];
    license = [ licenses.gpl2Only ];
    platforms = [ "i686-linux" "x86_64-linux" ];
    broken = versionOlder kernel.version "4.14";
    description = "System76 ACPI Driver (DKMS)";
    homepage = "https://github.com/pop-os/system76-acpi-dkms";
    longDescription = ''
      This provides the system76_acpi in-tree driver for systems missing it.
    '';
  };
}
