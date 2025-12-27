{ callPackage, stdenv }:
{
  rocm = callPackage ./ffvship.nix { gpuBackend = "rocm"; };
  cuda = callPackage ./ffvship.nix { gpuBackend = "cuda"; };
}
