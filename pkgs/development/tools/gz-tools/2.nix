{
  callPackage,
  fetchpatch,
  gz-cmake_3,
}:

(callPackage ./generic.nix {
  gz-cmake = gz-cmake_3;
})
  {
    version = "2.0.1";
    hash = "sha256-sV/T53oVk1fgjwqn/SRTaPTukt+vAlGGxGvTN8+G6Mo=";
  }
