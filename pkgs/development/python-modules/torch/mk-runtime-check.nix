{
  cudaPackages,
  feature,
  torch,
  versionAttr,
}:

cudaPackages.writeGpuTestPython
  {
    inherit feature;
    libraries = [ torch ];
    name = "${feature}Available";
  }
  ''
    import torch
    message = f"{torch.cuda.is_available()=} and {torch.version.${versionAttr}=}"
    assert torch.cuda.is_available() and torch.version.${versionAttr}, message
    print(message)
  ''
