{ lib
, pkgs
, vulkanVersions ? import ./versions.nix
}:
(lib.makeScope pkgs.newScope (self:
let
  callPackage = self.callPackage;
in
{
  inherit vulkanVersions;

  gfxreconstruct = callPackage ./gfxreconstruct { };

  glslang = callPackage ./glslang { };

  spirv-cross = callPackage ./spirv-cross { };
  spirv-headers = callPackage ./spirv-headers { };
  spirv-tools = callPackage ./spirv-tools { };

  vulkan-extension-layer = callPackage ./vulkan-extension-layer { };
  vulkan-headers = callPackage ./vulkan-headers { };
  vulkan-loader = callPackage ./vulkan-loader {
    inherit (pkgs.darwin) moltenvk;
  };
  vulkan-tools = callPackage ./vulkan-tools {
    inherit (pkgs.darwin) moltenvk;
    inherit (pkgs.darwin.apple_sdk.frameworks) AppKit Cocoa;
  };
  vulkan-tools-lunarg = callPackage ./vulkan-tools-lunarg { };
  vulkan-validation-layers = callPackage ./vulkan-validation-layers { };
}))
