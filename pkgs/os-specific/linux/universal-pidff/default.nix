{
  stdenv,
  lib,
  fetchFromGitHub,
  kernel,
}:

stdenv.mkDerivation rec {
  pname = "universal-pidff";
  version = "0.0.8";

  src = fetchFromGitHub {
    owner = "JacKeTUs";
    repo = "universal-pidff";
    rev = "refs/tags/${version}";
    hash = "sha256-DptLqyjfRCpkbyFAQI8sylyKu2XyZZGrSITva9vcXGQ=";
  };

  postPatch = ''
    sed -i 's|depmod|#depmod|' Makefile
  '';

  hardeningDisable = [
    "pic"
    "format"
  ];
  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = [
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
      danerieber
      racci
    ];
    platforms = lib.platforms.linux;
  };
}
