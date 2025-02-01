{
  cudaPackages,
  feature,
  libraries,
  versionAttr,
  pythonPackages,
}:

(cudaPackages.writeGpuTestPython.override { python3Packages = pythonPackages; })
  {
    inherit feature;
    inherit libraries;
    name = "${feature}Available";
  }
  ''
    import torch
    message = f"{torch.cuda.is_available()=} and {torch.version.${versionAttr}=}"
    assert torch.cuda.is_available() and torch.version.${versionAttr}, message
    print(message)
  ''
