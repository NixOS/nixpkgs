{
  stdenv,
  lib,
  fetchFromGitHub,
  kernel,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xone";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "dlundqvist";
    repo = "xone";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qMZlQgAe5vB5zfuhyK7EBxIwfhnC5MvnF/qr3BGnDms=";
  };

  setSourceRoot = ''
    export sourceRoot=$(pwd)/${finalAttrs.src.name}
  '';

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = [
    "-C"
    "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "M=$(sourceRoot)"
    "VERSION=${finalAttrs.version}"
  ];

  enableParallelBuilding = true;
  buildFlags = [ "modules" ];
  installFlags = [ "INSTALL_MOD_PATH=${placeholder "out"}" ];
  installTargets = [ "modules_install" ];

  meta = with lib; {
    description = "Linux kernel driver for Xbox One and Xbox Series X|S accessories";
    homepage = "https://github.com/dlundqvist/xone";
    license = licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      rhysmdnz
      fazzi
    ];
    platforms = platforms.linux;
    broken = kernel.kernelOlder "6";
  };
})
