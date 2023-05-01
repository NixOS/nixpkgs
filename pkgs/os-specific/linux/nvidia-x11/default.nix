{ lib, callPackage, fetchFromGitHub, fetchurl, fetchpatch, stdenv, pkgsi686Linux }:

let
  generic = args: let
    imported = import ./generic.nix args;
  in callPackage imported {
    lib32 = (pkgsi686Linux.callPackage imported {
      libsOnly = true;
      kernel = null;
    }).out;
  };

  kernel = callPackage # a hacky way of extracting parameters from callPackage
    ({ kernel, libsOnly ? false }: if libsOnly then { } else kernel) { };

  selectHighestVersion = a: b: if lib.versionOlder a.version b.version
    then b
    else a;
in
rec {
  # Official Unix Drivers - https://www.nvidia.com/en-us/drivers/unix/
  # Branch/Maturity data - http://people.freedesktop.org/~aplattner/nvidia-versions.txt

  # Policy: use the highest stable version as the default (on our master).
  stable = if stdenv.hostPlatform.system == "i686-linux" then legacy_390 else latest;

  production = generic {
    version = "525.116.03";
    sha256_64bit = "sha256-XClbAuvsLpqewNebqSkutiO0svu6im7WGQYJKaMNBGk=";
    sha256_aarch64 = "sha256-x4FZxtMDtlSwLvh0rCTdFp8+lCPoxdevCDA+b3I8De4=";
    openSha256 = "sha256-AiUWHwVjXiii4hckWcFFGPyvSJfWqBlRi+lZKdfGsKM=";
    settingsSha256 = "sha256-PgyV8YzEtLTER4ucnZuRjA2LkX1kqy+k0am0k9Ci40Q=";
    persistencedSha256 = "sha256-Ok20+fGlTlmMyROzIPQ+V+cStsM7BTabTVORJTNZDf4=";

    ibtSupport = true;
  };

  latest = selectHighestVersion production (generic {
    version = "530.41.03";
    sha256_64bit = "sha256-riehapaMhVA/XRYd2jQ8FgJhKwJfSu4V+S4uoKy3hLE=";
    sha256_aarch64 = "sha256-uM5zMEO/AO32VmqUOzmc05FFm/lz76jPSSaQmeZUlFo=";
    openSha256 = "sha256-etbtw6LMRUcFoZC9EDDRrTDekV8JFRYmkp3idLaMk5g=";
    settingsSha256 = "sha256-8KB6T9f+gWl8Ni+uOyrJKiiH5mNx9eyfCcW/RjPTQQA=";
    persistencedSha256 = "sha256-zrstlt/0YVGnsPGUuBbR9ULutywi2wNDVxh7OhJM7tM=";
  });

  beta = selectHighestVersion latest (generic {
    version = "530.30.02";
    sha256_64bit = "sha256-R/3bvXoiumYZI9vObn9R7sVN9oBQxAbMBJDDv77eeWM=";
    sha256_aarch64 = "sha256-/b5Jdow+O7ExXjtXTzDX38qgmBDUYDUl+5zxXvbi1ts=";
    openSha256 = "sha256-LCtTyuJ8s8isTBt9HetItLqSjL1GOn0tPUarjuxHpMk=";
    settingsSha256 = "sha256-6mynLNSaWeiB52HdwZ0EQNyPg+tuat0oEqpZGSb2yQo=";
    persistencedSha256 = "sha256-h6iq0iD9F41a7s6jWKPTI+oVzgDRIr1Kk97LNH9rg7E=";
  });

  # Vulkan developer beta driver
  # See here for more information: https://developer.nvidia.com/vulkan-driver
  vulkan_beta = generic rec {
    version = "525.47.22";
    persistencedVersion = "525.85.05";
    settingsVersion = "525.85.05";
    sha256_64bit = "sha256-y8XgeGljiR2q/Wzp2btCQ8Wa+9KvWsWxZHb+NIqfCYQ=";
    openSha256 = "sha256-Y8XL8BJWSV2K1p4VR8T9Z2DOqySgQqkB4Dvf6E6vcxI=";
    settingsSha256 = "sha256-ck6ra8y8nn5kA3L9/VcRR2W2RaWvfVbgBiOh2dRJr/8=";
    persistencedSha256 = "sha256-dt/Tqxp7ZfnbLel9BavjWDoEdLJvdJRwFjTFOBYYKLI=";
    url = "https://developer.nvidia.com/downloads/vulkan-beta-${lib.concatStrings (lib.splitString "." version)}-linux";
  };

  # Update note:
  # If you add a legacy driver here, also update `top-level/linux-kernels.nix`,
  # adding to the `nvidia_x11_legacy*` entries.

  # Last one supporting Kepler architecture
  legacy_470 = generic {
    version = "470.182.03";
    sha256_64bit = "sha256-PbwUCPxIuGXT3azvxF9KP8E7kLg6Yo7lRrAIKrLD/Hk=";
    sha256_aarch64 = "sha256-FEoWikgQjZKkHvAHgtkxnDhB41GdYplZTttEUBit4QQ=";
    settingsSha256 = "sha256-TRKQ4brLnCbBZt1smGSIHTfwW+wEFPWWPEwDxjVXN7s=";
    persistencedSha256 = "sha256-fSJMx49z9trdNxx0iPI45oG57smvvhaqVNxsRnfXKCI=";

    prePatch = "pushd kernel";
    postPatch = "popd";

    patches = [
      # source: https://gist.github.com/joanbm/d10e9cbbbb8e245b6e7e27b2db338faf
      (fetchpatch {
        url = "https://gist.github.com/joanbm/d10e9cbbbb8e245b6e7e27b2db338faf/raw/f5d5238bdbaa16cd4008658a0f82b9dd84f1b38f/nvidia-470xx-fix-linux-6.3.patch";
        hash = "sha256-mR+vXDHgVhWC0JeLgGlbNVCH8XTs7XnhEJS6BV75tI8=";
      })
    ];
  };

  # Last one supporting x86
  legacy_390 = generic {
    version = "390.157";
    sha256_32bit = "sha256-VdZeCkU5qct5YgDF8Qgv4mP7CVHeqvlqnP/rioD3B5k=";
    sha256_64bit = "sha256-W+u8puj+1da52BBw+541HxjtxTSVJVPL3HHo/QubMoo=";
    settingsSha256 = "sha256-uJZO4ak/w/yeTQ9QdXJSiaURDLkevlI81de0q4PpFpw=";
    persistencedSha256 = "sha256-NuqUQbVt80gYTXgIcu0crAORfsj9BCRooyH3Gp1y1ns=";
  };

  legacy_340 = let
    # Source cooresponding to https://aur.archlinux.org/packages/nvidia-340xx-dkms
    aurPatches = fetchFromGitHub {
      owner = "archlinux-jerry";
      repo = "nvidia-340xx";
      rev = "fe2b38e66f2199777bcede6eb35c5df0210f15dc";
      hash = "sha256-hPFfzWGo2jF/DLm1OkP+BBnRY69N8kKUZ1EGkoHJlKA=";
    };
    patchset = [
      "0001-kernel-5.7.patch"
      "0002-kernel-5.8.patch"
      "0003-kernel-5.9.patch"
      "0004-kernel-5.10.patch"
      "0005-kernel-5.11.patch"
      "0006-kernel-5.14.patch"
      "0007-kernel-5.15.patch"
      "0008-kernel-5.16.patch"
      "0009-kernel-5.17.patch"
      "0010-kernel-5.18.patch"
      "0011-kernel-6.0.patch"
    ];
  in generic {
    version = "340.108";
    sha256_32bit = "1jkwa1phf0x4sgw8pvr9d6krmmr3wkgwyygrxhdazwyr2bbalci0";
    sha256_64bit = "06xp6c0sa7v1b82gf0pq0i5p0vdhmm3v964v0ypw36y0nzqx8wf6";
    settingsSha256 = "0zm29jcf0mp1nykcravnzb5isypm8l8mg2gpsvwxipb7nk1ivy34";
    persistencedSha256 = "1ax4xn3nmxg1y6immq933cqzw6cj04x93saiasdc0kjlv0pvvnkn";
    useGLVND = false;

    broken = kernel.kernelAtLeast "6.2";
    patches = map (patch: "${aurPatches}/${patch}") patchset;
  };
}
