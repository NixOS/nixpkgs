{ lib, stdenv, fetchFromGitHub, kernel }:
let
  version = "1.0.16";
  hash = "sha256-jsBLy5WDl2l8o/2ccIk1XMqOukeDX5eZ+VH5Dyo5BaA=";
in
stdenv.mkDerivation {
  name = "system76-module-${version}-${kernel.version}";

  passthru.moduleName = "system76";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "system76-dkms";
    rev = version;
    inherit hash;
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  buildFlags = [
    "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  installPhase = ''
    install -D system76.ko $out/lib/modules/${kernel.modDirVersion}/misc/system76.ko
    mkdir -p $out/lib/udev/hwdb.d
    mv lib/udev/hwdb.d/* $out/lib/udev/hwdb.d
  '';

  meta = {
    maintainers = [ lib.maintainers.khumba ];
    license = [ lib.licenses.gpl2Plus ];
    platforms = [ "i686-linux" "x86_64-linux" ];
    description = "System76 DKMS driver";
    homepage = "https://github.com/pop-os/system76-dkms";
    longDescription = ''
      The System76 DKMS driver. On newer System76 laptops, this driver controls
      some of the hotkeys and allows for custom fan control.
    '';
  };
}
