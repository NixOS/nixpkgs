{
  stdenv,
  lib,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xone";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "dlundqvist";
    repo = "xone";
    tag = "v${finalAttrs.version}";
    hash = "sha256-d70H/uuW3YINS6utBdjMDVLyS6wZoyN92xJ/YA7wMRo=";
  };

  setSourceRoot = ''
    export sourceRoot=$(pwd)/${finalAttrs.src.name}
  '';

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernelModuleMakeFlags ++ [
    "-C"
    "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "M=$(sourceRoot)"
    "VERSION=${finalAttrs.version}"
  ];

  enableParallelBuilding = true;
  buildFlags = [ "modules" ];
  installFlags = [ "INSTALL_MOD_PATH=${placeholder "out"}" ];
  installTargets = [ "modules_install" ];

  meta = {
    description = "Linux kernel driver for Xbox One and Xbox Series X|S accessories";
    homepage = "https://github.com/dlundqvist/xone";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      rhysmdnz
      fazzi
    ];
    platforms = lib.platforms.linux;
    broken = kernel.kernelOlder "6.5";
  };
})
