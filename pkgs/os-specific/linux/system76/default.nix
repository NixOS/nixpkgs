{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
}:
let
  hash = "sha256-9/t+Mvfnq0KkPbe1mnrVy4mzNaK7vAgLuhUnOeEvBfI=";
in
stdenv.mkDerivation (finalAttrs: {
  name = "${finalAttrs.pname}-${finalAttrs.version}-${kernel.version}";
  pname = "system76-module";
  version = "1.0.17";

  passthru.moduleName = "system76";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "system76-dkms";
    rev = finalAttrs.version;
    inherit hash;
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernelModuleMakeFlags ++ [
    "INSTALL_MOD_PATH=${placeholder "out"}"
    "INSTALL_MOD_DIR=misc"
    "INSTALL_MOD_STRIP=1"
    "DEPMOD=true"
  ];

  buildFlags = [
    "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  installTargets = [ "modules_install" ];

  installFlags = [
    "-C"
    "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "M=$(PWD)"
  ];

  postInstall = ''
    mkdir -p $out/lib/udev/hwdb.d
    mv lib/udev/hwdb.d/* $out/lib/udev/hwdb.d
  '';

  meta = {
    maintainers = with lib.maintainers; [ ahoneybun ];
    license = lib.licenses.gpl2Plus;
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
    description = "System76 DKMS driver";
    homepage = "https://github.com/pop-os/system76-dkms";
    longDescription = ''
      The System76 DKMS driver. On newer System76 laptops, this driver controls
      some of the hotkeys and allows for custom fan control.
    '';
  };
})
