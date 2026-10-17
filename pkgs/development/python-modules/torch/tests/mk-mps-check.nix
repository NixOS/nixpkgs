{
  cudaPackages,
  lib,
  libraries,
}:

cudaPackages.writeGpuTestPython
  {
    inherit libraries;
    feature = null;
    name = "mps";
    meta.platforms = lib.platforms.darwin;
    gpuCheckArgs.meta.platforms = lib.platforms.darwin;
  }
  ''
    import torch

    assert torch.backends.mps.is_built(), "MPS backend is not built"

    if torch.backends.mps.is_available():
        t = torch.randn(3, 3, device="mps")
        result = t @ t.T
        print(f"MPS computation result:\n{result}")
    else:
        print("MPS backend is built but no MPS device available")
  ''
