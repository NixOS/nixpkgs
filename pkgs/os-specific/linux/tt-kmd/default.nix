{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "tt-kmd";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "tenstorrent";
    repo = "tt-kmd";
    tag = "ttkmd-${finalAttrs.version}";
    hash = "sha256-MCfz5c42Jtm/SoTjyD+P5DgSzJy0T/VpwShuJNyPyTM=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernelModuleMakeFlags;

  buildFlags = [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  installFlags = finalAttrs.buildFlags ++ [
    "INSTALL_MOD_PATH=${placeholder "out"}"
    "INSTALL_MOD_DIR=misc"
  ];

  installTargets = [ "modules_install" ];

  postInstall = ''
    mkdir -p $out/lib/udev/rules.d
    cp udev-50-tenstorrent.rules $out/lib/udev/rules.d/50-tenstorrent.rules
  '';

  meta = {
    description = "Tenstorrent Kernel Module";
    homepage = "https://github.com/tenstorrent/tt-kmd";
    maintainers = with lib.maintainers; [ RossComputerGuy ];
    license = with lib.licenses; [ gpl2Only ];
    platforms = lib.platforms.linux;
  };
})
