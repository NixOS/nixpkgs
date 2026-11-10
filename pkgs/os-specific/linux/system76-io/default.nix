{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
}:
let
  hash = "sha256-VE6sCehjXlRuOVcK4EN2H+FhaVaBi/jrAYx4TZjbreA=";
in
stdenv.mkDerivation (finalAttrs: {
  name = "${finalAttrs.pname}-${finalAttrs.version}-${kernel.version}";
  pname = "system76-io-module";
  version = "1.0.4";

  passthru.moduleName = "system76_io";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "system76-io-dkms";
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

  meta = {
    maintainers = with lib.maintainers; [ ahoneybun ];
    license = lib.licenses.gpl2Plus;
    platforms = [
      "i686-linux"
      "x86_64-linux"
      "aarch64-linux"
    ];
    broken = lib.versionOlder kernel.version "5.10";
    description = "DKMS module for controlling System76 Io board";
    homepage = "https://github.com/pop-os/system76-io-dkms";
  };
})
