{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  kernelModuleInstallHook,
  kernelModuleMakeFlags,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "tt-kmd";
  version = "2.11.0";

  src = fetchFromGitHub {
    owner = "tenstorrent";
    repo = "tt-kmd";
    tag = "ttkmd-${finalAttrs.version}";
    hash = "sha256-Wjxz8kfRNeq0CpGn0M4ro6XnuyyUyYFV1Y6sOGHzkA0=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies ++ [ kernelModuleInstallHook ];

  makeFlags = kernelModuleMakeFlags;

  buildFlags = [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  kernelModuleInstallDir = "misc";

  postInstall = ''
    mkdir -p $out/lib/udev/rules.d
    cp udev-50-tenstorrent.rules $out/lib/udev/rules.d/50-tenstorrent.rules
  '';

  meta = {
    description = "Tenstorrent Kernel Module";
    homepage = "https://github.com/tenstorrent/tt-kmd";
    teams = [ lib.teams.tenstorrent ];
    maintainers = with lib.maintainers; [ RossComputerGuy ];
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
  };
})
