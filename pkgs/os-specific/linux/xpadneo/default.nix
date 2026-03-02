{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
  nixosTests,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xpadneo";
  version = "0.9.8";

  src = fetchFromGitHub {
    owner = "atar-axis";
    repo = "xpadneo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-C4hBVr/8KM3uw5RF9PyN2uQvsWnb1thXDF5VMVD2SCQ=";
  };

  setSourceRoot = ''
    export sourceRoot=$(pwd)/${finalAttrs.src.name}/hid-xpadneo/src
  '';

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernelModuleMakeFlags ++ [
    "-C"
    "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "M=$(sourceRoot)"
    "VERSION=${finalAttrs.version}"
  ];

  buildFlags = [ "modules" ];
  installFlags = [ "INSTALL_MOD_PATH=${placeholder "out"}" ];
  installTargets = [ "modules_install" ];

  passthru.tests = {
    xpadneo = nixosTests.xpadneo;
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Advanced Linux driver for Xbox One wireless controllers";
    homepage = "https://atar-axis.github.io/xpadneo";
    changelog = "https://github.com/atar-axis/xpadneo/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ kira-bruneau ];
    platforms = lib.platforms.linux;
  };
})
