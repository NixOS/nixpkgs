{
  lib,
  fetchurl,
  buildLinux,
  ...
}@args:

let
  version = "6.10.9";
in
buildLinux (
  args
  // {
    inherit version;
    pname = "linux-g14";
    modDirVersion = version;
    src = fetchurl {
      url = "mirror://kernel/linux/kernel/v${lib.versions.major version}.x/linux-${version}.tar.xz";
      hash = "sha256:0n385x7hc5pqxiiy26ampgzf56wqfvydg70va27xrhm7w1q9nj54";
    };
    kernelPatches =
      let
        g14-patch = {
          name = "g14";
          patch = fetchurl {
            url = "https://gitlab.com/asus-linux/fedora-kernel/-/raw/rog-6.10/asus-patch-series.patch";
            hash = "sha256-e296MVs/xJRN+gXzRKluxj8kKR8//GpFdxRfQLpdJj8=";
          };
        };
        amdgpu-cleared-vram-for-GEM-allocations-patch = {
          name = "amdgpu-cleared-vram-for-GEM-allocations";
          patch = fetchurl {
            url = "https://gitlab.freedesktop.org/agd5f/linux/-/commit/4de34b04783628f14614badb0a1aa67ce3fcef5d.patch";
            hash = "sha256-fJcMwupXQ74aoeC2tr4KdUZpkv1qaXUZAn7cbqgBLJw=";
          };
        };
      in
      [
        g14-patch
        amdgpu-cleared-vram-for-GEM-allocations-patch
      ];
    structuredExtraConfig = with lib.kernel; {
      HID_ASUS_ALLY = module;
      ASUS_ARMOURY = module;
      ASUS_WMI_BIOS = yes;
    };
    extraMeta = {
      branch = lib.versions.majorMinor version;
    };
  }
)
