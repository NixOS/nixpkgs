{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  kernel,
  kernelModuleMakeFlags,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "aws-neuronx";
  version = "2.31.7.0";
  name = "${finalAttrs.pname}-${finalAttrs.version}-${kernel.version}";

  __structuredAttrs = true;
  strictDeps = true;
  enableParallelBuilding = true;

  src = fetchFromGitHub {
    owner = "aws-neuron";
    repo = "aws-neuron-driver";
    tag = finalAttrs.version;
    hash = "sha256-FkGAyDjHit7aYajMaJoF4tVDHbfb+8OlCze+ZMIr8kA=";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernelModuleMakeFlags ++ [
    "-C"
    "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "M=$(PWD)"
  ];

  buildFlags = [ "modules" ];

  installTargets = [ "modules_install" ];

  installFlags = [
    "INSTALL_MOD_PATH=${placeholder "out"}"
  ];

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Kernel driver supporting AWS Neuron SDK (Inferentia/Trainium)";
    homepage = "https://github.com/aws-neuron/aws-neuron-driver";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [
      ethancedwards8
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
