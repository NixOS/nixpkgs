{ callPackage }:
let
  # this GPU families are supported "by-default" upstream (see https://github.com/Syllo/nvtop/blob/3a69c2d060298cd6f92cb09db944eded98be1c23/CMakeLists.txt#L81)
  # coincidentally, these families are also easy to build in nixpkgs at the moment
  defaultGPUFamilies = [ "amd" "intel" "msm" "nvidia" "panfrost" "panthor" ];
  # these GPU families are partially supported upstream, they are also tricky to build in nixpkgs
  # volunteers with specific hardware needed to build and test these package variants
  additionalGPUFamilies = [ "apple" "ascend" ];
  defaultSupport = builtins.listToAttrs (builtins.map (gpu: { name = gpu; value = true; }) defaultGPUFamilies);
in
{
  full = callPackage ./build-nvtop.nix defaultSupport; #this package supports all default GPU families
}
# additional packages with only one specific GPU family support
// builtins.listToAttrs (builtins.map (gpu: { name = gpu; value = (callPackage ./build-nvtop.nix { "${gpu}" = true; }); }) defaultGPUFamilies)



