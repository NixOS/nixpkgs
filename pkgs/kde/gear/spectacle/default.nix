{
  lib,
  config,
  mkKdeDerivation,
  qtwayland,
  qtmultimedia,
  opencv,
  cudaSupport ? config.cudaSupport,
  cudaPackages,
}:
mkKdeDerivation {
  pname = "spectacle";

  extraBuildInputs = [
    qtwayland
    qtmultimedia
    opencv
  ] ++ lib.optionals cudaSupport [
    cudaPackages.cuda_cudart
    cudaPackages.cuda_nvcc
  ];

  meta.mainProgram = "spectacle";
}
