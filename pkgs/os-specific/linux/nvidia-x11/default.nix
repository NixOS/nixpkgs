{
  lib,
  callPackage,
  fetchFromGitHub,
  fetchgit,
  fetchpatch,
  stdenv,
  pkgsi686Linux,
}:

let
  generic =
    args:
    let
      imported = import ./generic.nix args;
    in
    callPackage imported {
      lib32 =
        (pkgsi686Linux.callPackage imported {
          libsOnly = true;
          kernel = null;
        }).out;
    };

  kernel =
    # a hacky way of extracting parameters from callPackage
    callPackage (
      {
        kernel,
        libsOnly ? false,
      }:
      if libsOnly then { } else kernel
    ) { };

  selectHighestVersion = a: b: if lib.versionOlder a.version b.version then b else a;

  # https://forums.developer.nvidia.com/t/linux-6-7-3-545-29-06-550-40-07-error-modpost-gpl-incompatible-module-nvidia-ko-uses-gpl-only-symbol-rcu-read-lock/280908/19
  rcu_patch = fetchpatch {
    url = "https://github.com/gentoo/gentoo/raw/c64caf53/x11-drivers/nvidia-drivers/files/nvidia-drivers-470.223.02-gpl-pfn_valid.patch";
    hash = "sha256-eZiQQp2S/asE7MfGvfe6dA/kdCvek9SYa/FFGp24dVg=";
  };

  # Fixes drm device not working with linux 6.12
  # https://github.com/NVIDIA/open-gpu-kernel-modules/issues/712
  drm_fop_flags_linux_612_patch = fetchpatch {
    url = "https://github.com/Binary-Eater/open-gpu-kernel-modules/commit/8ac26d3c66ea88b0f80504bdd1e907658b41609d.patch";
    hash = "sha256-+SfIu3uYNQCf/KXhv4PWvruTVKQSh4bgU1moePhe57U=";
  };

  # Source corresponding to https://aur.archlinux.org/packages/nvidia-390xx-dkms
  aurPatches = fetchgit {
    url = "https://aur.archlinux.org/nvidia-390xx-utils.git";
    rev = "cf1a1c571c425b4b66d12e468fc4ce45a397c583";
    hash = "sha256-SERB5ihOroagJn7apAiqjUckbrfP2FZPCuTLWcBccoM=";
  };

  # https://github.com/NVIDIA/open-gpu-kernel-modules/issues/840
  gpl_symbols_linux_615_patch = fetchpatch {
    url = "https://github.com/CachyOS/kernel-patches/raw/914aea4298e3744beddad09f3d2773d71839b182/6.15/misc/nvidia/0003-Workaround-nv_vm_flags_-calling-GPL-only-code.patch";
    hash = "sha256-YOTAvONchPPSVDP9eJ9236pAPtxYK5nAePNtm2dlvb4=";
    stripLen = 1;
    extraPrefix = "kernel/";
  };
in
rec {
  mkDriver = generic;

  # Official Unix Drivers - https://www.nvidia.com/en-us/drivers/unix/
  # Branch/Maturity data - http://people.freedesktop.org/~aplattner/nvidia-versions.txt

  # Policy: use the highest stable version as the default (on our master).
  stable = if stdenv.hostPlatform.system == "i686-linux" then legacy_390 else production;

  production = generic {
    version = if stdenv.hostPlatform.system == "aarch64-linux" then "580.95.05" else "580.105.08";
    sha256_64bit =
      if stdenv.hostPlatform.system == "aarch64-linux" then
        "sha256-hJ7w746EK5gGss3p8RwTA9VPGpp2lGfk5dlhsv4Rgqc="
      else
        "sha256-2cboGIZy8+t03QTPpp3VhHn6HQFiyMKMjRdiV2MpNHU=";
    sha256_aarch64 =
      if stdenv.hostPlatform.system == "aarch64-linux" then
        "sha256-zLRCbpiik2fGDa+d80wqV3ZV1U1b4lRjzNQJsLLlICk="
      else
        null;
    openSha256 =
      if stdenv.hostPlatform.system == "aarch64-linux" then
        "sha256-RFwDGQOi9jVngVONCOB5m/IYKZIeGEle7h0+0yGnBEI="
      else
        "sha256-FGmMt3ShQrw4q6wsk8DSvm96ie5yELoDFYinSlGZcwQ=";
    settingsSha256 =
      if stdenv.hostPlatform.system == "aarch64-linux" then
        "sha256-F2wmUEaRrpR1Vz0TQSwVK4Fv13f3J9NJLtBe4UP2f14="
      else
        "sha256-YvzWO1U3am4Nt5cQ+b5IJ23yeWx5ud1HCu1U0KoojLY=";
    persistencedSha256 =
      if stdenv.hostPlatform.system == "aarch64-linux" then
        "sha256-QCwxXQfG/Pa7jSTBB0xD3lsIofcerAWWAHKvWjWGQtg="
      else
        "sha256-qh8pKGxUjEimCgwH7q91IV7wdPyV5v5dc5/K/IcbruI=";
  };

  latest = selectHighestVersion production (generic {
    version = "575.64.05";
    sha256_64bit = "sha256-hfK1D5EiYcGRegss9+H5dDr/0Aj9wPIJ9NVWP3dNUC0=";
    sha256_aarch64 = "sha256-GRE9VEEosbY7TL4HPFoyo0Ac5jgBHsZg9sBKJ4BLhsA=";
    openSha256 = "sha256-mcbMVEyRxNyRrohgwWNylu45vIqF+flKHnmt47R//KU=";
    settingsSha256 = "sha256-o2zUnYFUQjHOcCrB0w/4L6xI1hVUXLAWgG2Y26BowBE=";
    persistencedSha256 = "sha256-2g5z7Pu8u2EiAh5givP5Q1Y4zk4Cbb06W37rf768NFU=";
  });

  beta = selectHighestVersion latest (generic {
    version = "590.44.01";
    sha256_64bit = "sha256-VbkVaKwElaazojfxkHnz/nN/5olk13ezkw/EQjhKPms=";
    sha256_aarch64 = "sha256-gpqz07aFx+lBBOGPMCkbl5X8KBMPwDqsS+knPHpL/5g=";
    openSha256 = "sha256-ft8FEnBotC9Bl+o4vQA1rWFuRe7gviD/j1B8t0MRL/o=";
    settingsSha256 = "sha256-wVf1hku1l5OACiBeIePUMeZTWDQ4ueNvIk6BsW/RmF4=";
    persistencedSha256 = "sha256-nHzD32EN77PG75hH9W8ArjKNY/7KY6kPKSAhxAWcuS4=";
  });

  # Vulkan developer beta driver
  # See here for more information: https://developer.nvidia.com/vulkan-driver
  vulkan_beta = generic rec {
    version = "580.94.11";
    persistencedVersion = "580.95.05";
    settingsVersion = "580.95.05";
    sha256_64bit = "sha256-zcyK5mz8XubxdjdNbTJvaIHW1ehyV4jKZ8kNByKNDQU=";
    openSha256 = "sha256-Eb6RJo4u08lWp1cs8WBThPH7r90Pj6MPtUYI5N3rOEI=";
    settingsSha256 = "sha256-F2wmUEaRrpR1Vz0TQSwVK4Fv13f3J9NJLtBe4UP2f14=";
    persistencedSha256 = "sha256-QCwxXQfG/Pa7jSTBB0xD3lsIofcerAWWAHKvWjWGQtg=";
    url = "https://developer.nvidia.com/downloads/vulkan-beta-${lib.concatStrings (lib.splitVersion version)}-linux";
  };

  # data center driver compatible with current default cudaPackages
  dc = dc_570;

  dc_535 = generic rec {
    version = "535.154.05";
    url = "https://us.download.nvidia.com/tesla/${version}/NVIDIA-Linux-x86_64-${version}.run";
    sha256_64bit = "sha256-fpUGXKprgt6SYRDxSCemGXLrEsIA6GOinp+0eGbqqJg=";
    persistencedSha256 = "sha256-d0Q3Lk80JqkS1B54Mahu2yY/WocOqFFbZVBh+ToGhaE=";
    fabricmanagerSha256 = "sha256-/HQfV7YA3MYVmre/sz897PF6tc6MaMiS/h7Q10m2p/o=";
    useSettings = false;
    usePersistenced = true;
    useFabricmanager = true;

    patches = [ rcu_patch ];
  };

  # Drop after next nixos release
  dc_565 = generic rec {
    version = "565.57.01";
    url = "https://us.download.nvidia.com/tesla/${version}/NVIDIA-Linux-x86_64-${version}.run";
    sha256_64bit = "sha256-buvpTlheOF6IBPWnQVLfQUiHv4GcwhvZW3Ks0PsYLHo=";
    persistencedSha256 = "sha256-hdszsACWNqkCh8G4VBNitDT85gk9gJe1BlQ8LdrYIkg=";
    fabricmanagerSha256 = "sha256-umhyehddbQ9+xhhoiKC7SOSVxscA5pcnqvkQOOLIdsM=";
    useSettings = false;
    usePersistenced = true;
    useFabricmanager = true;
  };

  dc_570 = generic rec {
    version = "570.172.08";
    url = "https://us.download.nvidia.com/tesla/${version}/NVIDIA-Linux-x86_64-${version}.run";
    sha256_64bit = "sha256-AlaGfggsr5PXsl+nyOabMWBiqcbHLG4ij617I4xvoX0=";
    persistencedSha256 = "sha256-x4K0Gp89LdL5YJhAI0AydMRxl6fyBylEnj+nokoBrK8=";
    fabricmanagerSha256 = "sha256-jSTKzeRVTUcYma1Cb0ajSdXKCi6KzUXCp2OByPSWSR4=";
    useSettings = false;
    usePersistenced = true;
    useFabricmanager = true;
  };

  # Update note:
  # If you add a legacy driver here, also update `top-level/linux-kernels.nix`,
  # adding to the `nvidia_x11_legacy*` entries.

  # Last one without the bug reported here:
  # https://bbs.archlinux.org/viewtopic.php?pid=2155426#p2155426
  legacy_535 = generic {
    version = "535.274.02";
    sha256_64bit = "sha256-O071TwaZHm3/94aN3nl/rZpFH+5o1SZ9+Hyivo5/KTs=";
    sha256_aarch64 = "sha256-PgHcrqGf4E+ttnpho+N8SKsMQxnZn29fffHXGbeAxRw=";
    openSha256 = "sha256-4KRHuTxlU0GT/cWf/j3aR7VqWpOez1ssS8zj/pYytes=";
    settingsSha256 = "sha256-BXQMXKybl9mmsp+Y+ht1RjZqnn/H3hZfyGcKIGurxrI=";
    persistencedSha256 = "sha256-/ZvAsvTjjiM/U3gn0DbxUguC3VvHbopyQ3u6+RYkzKk=";
  };

  # Last one supporting Kepler architecture
  legacy_470 =
    let
      # Source corresponding to https://aur.archlinux.org/packages/nvidia-470xx-dkms
      aurPatches = fetchgit {
        url = "https://aur.archlinux.org/nvidia-470xx-utils.git";
        rev = "7c1c2c124147d960a6c7114eb26a4eadae9b9f3d";
        hash = "sha256-sNW+I4dkPSudfORLEp1RNGHyQKWBYnBEeGrfJU7SYTs=";
      };
    in
    generic {
      version = "470.256.02";
      sha256_64bit = "sha256-1kUYYt62lbsER/O3zWJo9z6BFowQ4sEFl/8/oBNJsd4=";
      sha256_aarch64 = "sha256-e+QvE+S3Fv3JRqC9ZyxTSiCu8gJdZXSz10gF/EN6DY0=";
      settingsSha256 = "sha256-kftQ4JB0iSlE8r/Ze/+UMnwLzn0nfQtqYXBj+t6Aguk=";
      persistencedSha256 = "sha256-iYoSib9VEdwjOPBP1+Hx5wCIMhW8q8cCHu9PULWfnyQ=";

      patches = map (patch: "${aurPatches}/${patch}") [
        "0001-Fix-conftest-to-ignore-implicit-function-declaration.patch"
        "0002-Fix-conftest-to-use-a-short-wchar_t.patch"
        "0003-Fix-conftest-to-use-nv_drm_gem_vmap-which-has-the-se.patch"
        "nvidia-470xx-fix-gcc-15.patch"
        "kernel-6.10.patch"
        "kernel-6.12.patch"
        "nvidia-470xx-fix-linux-6.13.patch"
        "nvidia-470xx-fix-linux-6.14.patch"
        "nvidia-470xx-fix-linux-6.15.patch"
        "nvidia-470xx-fix-linux-6.17.patch"
      ];
      patchFlags = [
        "-p1"
        "--directory=kernel"
      ];
    };

  # Last one supporting x86
  legacy_390 = generic {
    version = "390.157";
    sha256_32bit = "sha256-VdZeCkU5qct5YgDF8Qgv4mP7CVHeqvlqnP/rioD3B5k=";
    sha256_64bit = "sha256-W+u8puj+1da52BBw+541HxjtxTSVJVPL3HHo/QubMoo=";
    settingsSha256 = "sha256-uJZO4ak/w/yeTQ9QdXJSiaURDLkevlI81de0q4PpFpw=";
    persistencedSha256 = "sha256-NuqUQbVt80gYTXgIcu0crAORfsj9BCRooyH3Gp1y1ns=";

    patches = map (patch: "${aurPatches}/${patch}") [
      "kernel-4.16+-memory-encryption.patch"
      "kernel-6.2.patch"
      "kernel-6.3.patch"
      "kernel-6.4.patch"
      "kernel-6.5.patch"
      "kernel-6.6.patch"
      "kernel-6.8.patch"
      "gcc-14.patch"
      "kernel-6.10.patch"
      "kernel-6.12.patch"
      "kernel-6.13.patch"
      "kernel-6.14.patch"
      "gcc-15.patch"
      "kernel-6.15.patch"
      "kernel-6.17.patch"
    ];
    broken = kernel.kernelAtLeast "6.18";

    # fixes the bug described in https://bbs.archlinux.org/viewtopic.php?pid=2083439#p2083439
    # see https://bbs.archlinux.org/viewtopic.php?pid=2083651#p2083651
    # and https://bbs.archlinux.org/viewtopic.php?pid=2083699#p2083699
    postInstall = ''
      mv $out/lib/tls/* $out/lib
      rmdir $out/lib/tls
    '';
  };

  legacy_340 =
    let
      # Source corresponding to https://aur.archlinux.org/packages/nvidia-340xx-dkms
      aurPatches = fetchFromGitHub {
        owner = "archlinux-jerry";
        repo = "nvidia-340xx";
        rev = "7616dfed253aa93ca7d2e05caf6f7f332c439c90";
        hash = "sha256-1qlYc17aEbLD4W8XXn1qKryBk2ltT6cVIv5zAs0jXZo=";
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
        "0012-kernel-6.2.patch"
        "0013-kernel-6.3.patch"
        "0014-kernel-6.5.patch"
        "0015-kernel-6.6.patch"
      ];
    in
    generic {
      version = "340.108";
      sha256_32bit = "1jkwa1phf0x4sgw8pvr9d6krmmr3wkgwyygrxhdazwyr2bbalci0";
      sha256_64bit = "06xp6c0sa7v1b82gf0pq0i5p0vdhmm3v964v0ypw36y0nzqx8wf6";
      settingsSha256 = "0zm29jcf0mp1nykcravnzb5isypm8l8mg2gpsvwxipb7nk1ivy34";
      persistencedSha256 = "1ax4xn3nmxg1y6immq933cqzw6cj04x93saiasdc0kjlv0pvvnkn";
      useGLVND = false;

      broken = kernel.kernelAtLeast "6.7";
      patches = map (patch: "${aurPatches}/${patch}") patchset;

      # fixes the bug described in https://bbs.archlinux.org/viewtopic.php?pid=2083439#p2083439
      # see https://bbs.archlinux.org/viewtopic.php?pid=2083651#p2083651
      # and https://bbs.archlinux.org/viewtopic.php?pid=2083699#p2083699
      postInstall = ''
        mv $out/lib/tls/* $out/lib
        rmdir $out/lib/tls
      '';
    };
}
