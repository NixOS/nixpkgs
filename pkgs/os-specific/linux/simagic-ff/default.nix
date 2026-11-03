{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "simagic-ff";
  version = "2.0.0-unstable-2026-09-27";

  src = fetchFromGitHub {
    owner = "JacKeTUs";
    repo = "simagic-ff";
    rev = "6fa8c4bc6e9ad09e3913630978f742785fdf6428";
    hash = "sha256-TvYMBSdaCYC383EgiaRJNRO23aN8lGXhQJSXTVY4T2k=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;
  strictDeps = true;

  # Build through Kbuild directly, avoiding the host kernel and depmod.
  makeFlags = kernelModuleMakeFlags ++ [
    "-C"
    "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "M=$(PWD)"
  ];
  buildFlags = [ "modules" ];
  installFlags = [ "INSTALL_MOD_PATH=${placeholder "out"}" ];
  installTargets = [ "modules_install" ];

  postInstall = ''
    install -Dm644 ${./70-simagic.rules} "$out/lib/udev/rules.d/70-simagic.rules"
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Force feedback driver for Simagic wheelbases";
    homepage = "https://github.com/JacKeTUs/simagic-ff";
    license = with lib.licenses; [
      gpl2Only
      gpl2Plus
    ];
    maintainers = [ lib.maintainers.jeremyrempel ];
    platforms = lib.platforms.linux;
  };
}
