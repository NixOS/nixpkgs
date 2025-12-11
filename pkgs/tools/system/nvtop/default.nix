{ callPackage, stdenv }:
let
  # this GPU families are supported "by-default" upstream (see https://github.com/Syllo/nvtop/blob/3a69c2d060298cd6f92cb09db944eded98be1c23/CMakeLists.txt#L81)
  # coincidentally, these families are also easy to build in nixpkgs at the moment
  defaultGPUFamilies = [
    "amd"
    "apple"
    "intel"
    "msm"
    "nvidia"
    "panfrost"
    "panthor"
    "v3d"
  ];
  # these GPU families are partially supported upstream, they are also tricky to build in nixpkgs
  # volunteers with specific hardware needed to build and test these package variants
  additionalGPUFamilies = [
    "ascend"
    "tpu"
  ];
  defaultSupport = builtins.listToAttrs (
    # apple can only build on darwin, and it can't build everything else, and vice versa
    map (gpu: {
      name = gpu;
      value =
        (gpu == "apple" && stdenv.buildPlatform.isDarwin && stdenv.hostPlatform == stdenv.buildPlatform)
        || (gpu != "apple" && stdenv.buildPlatform.isLinux);
    }) defaultGPUFamilies
  );
in
{
  full = callPackage ./build-nvtop.nix defaultSupport; # this package supports all default GPU families
}
# additional packages with only one specific GPU family support
// builtins.listToAttrs (
  map (gpu: {
    name = gpu;
    value = (callPackage ./build-nvtop.nix { "${gpu}" = true; });
  }) defaultGPUFamilies
)
