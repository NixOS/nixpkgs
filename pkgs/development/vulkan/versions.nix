# When upgrading vulkanPackages_sdk, remember to upgrade MoltenVK as well.
rec {
  sdkVersion = "1.3.243.0";
  sdkRev = "sdk-${sdkVersion}";

  # gfxreconstructVersion, gfxreconstructRev
  gfxreconstructHash = "sha256-/+leIYVJ5LtLvXQt3KzZex+MWc/e3v7FFbAw/hut46s=";

  # glslangVersion, glslangRev
  glslangHash = "sha256-U45/7G02o82EP4zh7i2Go0VCnsO1B7vxDwIokjyo5Rk=";

  # spirvVersion,  spirvRev
  spirvCrossHash = "sha256-snxbTI4q0YQq8T5NQD3kcsN59iJnhlLiu1Fvr+fCDeQ=";
  spirvHeadersHash = "sha256-VOq3r6ZcbDGGxjqC4IoPMGC5n1APUPUAs9xcRzxdyfk=";
  spirvToolsHash = "sha256-l44Ru0WjROQEDNU/2YQJGti1uDZP9osRdfsXus5EGX0=";

  # vulkanVersion, vulkanRev
  vulkanHeadersHash = "sha256-iitEA/x9QpbQrYTcV0OzBgnY6bQFhIm+mVq1ryIQ3+0=";
  vulkanLoaderHash = "sha256-DqgIg0jZxzhoyYrATDQMoNN/Pav9deKdltB7L0XDqPE=";

  # vulkanToolsVersion, vulkanToolsRev =>
  vulkanExtensionLayerHash = "sha256-hxlfSnH4M3ui5nW0Ll5rhto0DnJIHW0tJzS+p4KV0R4=";
  vulkanToolsHash = "sha256-8XJON+iBEPRtuQWf1bPXyOJHRkuRLnLXgTIjk7gYQwE=";
  vulkanToolsLunarGHash = "sha256-mvBP6wD1Z0VNLZ0mC4bA3i2IaBDtDr7K6XjHz4S3UA4=";
  vulkanValidationLayerHash = "sha256-viVceH8qFz6Cl/RlMMWZnMIdzULELlnIvtPZ87ySs2M=";
}
