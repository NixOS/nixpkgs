# When upgrading vulkanPackages_sdk, remember to upgrade MoltenVK as well.
rec {
  gfxreconstructVersion = "0.9.19";
  gfxreconstructRev = "v${gfxreconstructVersion}";
  gfxreconstructHash = "sha256-a1eMfVhBpnNoh0JTElHsPBfITlxeCbQKbDCGbj1ub1o=";

  glslangVersion = "12.1.0";
  glslangRev = glslangVersion;
  glslangHash = "sha256-U45/7G02o82EP4zh7i2Go0VCnsO1B7vxDwIokjyo5Rk=";

  # Same version as SDK
  spirvVersion = "1.3.243.0";
  spirvRev = "sdk-${spirvVersion}";
  spirvCrossHash = "sha256-snxbTI4q0YQq8T5NQD3kcsN59iJnhlLiu1Fvr+fCDeQ=";
  spirvHeadersHash = "sha256-VOq3r6ZcbDGGxjqC4IoPMGC5n1APUPUAs9xcRzxdyfk=";
  spirvToolsHash = "sha256-l44Ru0WjROQEDNU/2YQJGti1uDZP9osRdfsXus5EGX0=";

  vulkanVersion = "1.3.249";
  vulkanRev = "v${vulkanVersion}";
  vulkanHeadersHash = "sha256-PLqF9lO7vWvgRZvXLmOcNhTgkB+3TXUa0eoALwDc5Ws=";
  vulkanLoaderHash = "sha256-v4GEZEcQP3+oiT66sgysIZ2PdLSidyYjecb3TmcHG2Y=";

  vulkanToolsVersion = "1.3.249";
  vulkanToolsRev = "v${vulkanToolsVersion}";
  vulkanExtensionLayerHash = "sha256-a1eMfVhBpnNoh0JTElHsPBfITlxeCbQKbDCGbj1ub1o=";
  vulkanToolsHash = "sha256-+d0Yp+e/wzlRmUIs4SffiphkqmM/7avJrt3JNOgO19I=";
  vulkanToolsLunarGHash = "sha256-yQE6tjUxIZEMspxDaO9AoSjoEHQl2eDAc0E/aVQZnxQ=";
  vulkanValidationLayerHash = "sha256-+Vjy3hzzpC+bFNSEHLsfUaaHMSrMv2G+B8lGjui0fJs=";
}
