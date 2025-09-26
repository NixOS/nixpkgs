{
  stdenv,
  lib,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
}:

stdenv.mkDerivation rec {
  pname = "universal-pidff";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "JacKeTUs";
    repo = "universal-pidff";
    tag = version;
    hash = "sha256-qjnQTkQiufHPEwMH+F+XE+VBc/DSTX6d0vxot35xbUc=";
  };

  postPatch = ''
    sed -i 's|depmod|#depmod|' Makefile
  '';

  hardeningDisable = [
    "pic"
    "format"
  ];
  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernelModuleMakeFlags ++ [
    "KVERSION=${kernel.modDirVersion}"
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=$(out)"
  ];
  installTargets = [ "install" ];

  meta = {
    description = "PIDFF driver with useful patches for initialization of FFB devices";
    homepage = "https://github.com/JacKeTUs/universal-pidff";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      computerdane
      racci
    ];
    platforms = lib.platforms.linux;

    # Broken due to missing linux/minmax.h
    broken = kernel.kernelOlder "5.10";
  };
}
