{ lib, fetchFromGitHub, kernel, buildModule}:
let
  version = "1.0.13";
  sha256 = "162hhmnww8z9k0795ffs8v3f61hlfm375law156sk5l08if19a4r";
in
buildModule {
  pname = "system76-module";
  inherit version;

  passthru.moduleName = "system76";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "system76-dkms";
    rev = version;
    inherit sha256;
  };

  hardeningDisable = [ "pic" ];

  buildFlags = [
    "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  installPhase = ''
    install -D system76.ko $out/lib/modules/${kernel.modDirVersion}/misc/system76.ko
    mkdir -p $out/lib/udev/hwdb.d
    mv lib/udev/hwdb.d/* $out/lib/udev/hwdb.d
  '';

  overridePlatforms = [ "i686-linux" "x86_64-linux" ];

  meta = with lib; {
    maintainers = [ maintainers.khumba ];
    license = [ licenses.gpl2Plus ];
    broken = versionOlder kernel.version "4.14";
    description = "System76 DKMS driver";
    homepage = "https://github.com/pop-os/system76-dkms";
    longDescription = ''
      The System76 DKMS driver. On newer System76 laptops, this driver controls
      some of the hotkeys and allows for custom fan control.
    '';
  };
}
