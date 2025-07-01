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
    rev = "94dffc01e23a93c354a765ea7ac64484a3ef96c1";
    hash = "sha256-c94qXNZyMrSf7Dik7jvz2ECaGELqN7WEYNpnbUkzeeU=";
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
    version = "570.169";
    sha256_64bit = "sha256-XzKoR3lcxcP5gPeRiausBw2RSB1702AcAsKCndOHN2U=";
    sha256_aarch64 = "sha256-s8jqaZPcMYo18N2RDu8zwMThxPShxz/BL+cUsJnszts=";
    openSha256 = "sha256-oqY/O5fda+CVCXGVW2bX7LOa8jHJOQPO6mZ/EyleWCU=";
    settingsSha256 = "sha256-0E3UnpMukGMWcX8td6dqmpakaVbj4OhhKXgmqz77XZc=";
    persistencedSha256 = "sha256-dttFu+TmbFI+mt1MbbmJcUnc1KIJ20eHZDR7YzfWmgE=";
  };

  latest = selectHighestVersion production (generic {
    version = "575.64.03";
    sha256_64bit = "sha256-S7eqhgBLLtKZx9QwoGIsXJAyfOOspPbppTHUxB06DKA=";
    sha256_aarch64 = "sha256-s2Jm2wjdmXZ2hPewHhi6hmd+V1YQ+xmVxRWBt68mLUQ=";
    openSha256 = "sha256-SAl1+XH4ghz8iix95hcuJ/EVqt6ylyzFAao0mLeMmMI=";
    settingsSha256 = "sha256-o8rPAi/tohvHXcBV+ZwiApEQoq+ZLhCMyHzMxIADauI=";
    persistencedSha256 = "sha256-/3OAZx8iMxQLp1KD5evGXvp0nBvWriYapMwlMSc57h8=";
  });

  beta = selectHighestVersion latest (generic {
    version = "575.51.02";
    sha256_64bit = "sha256-XZ0N8ISmoAC8p28DrGHk/YN1rJsInJ2dZNL8O+Tuaa0=";
    sha256_aarch64 = "sha256-NNeQU9sPfH1sq3d5RUq1MWT6+7mTo1SpVfzabYSVMVI=";
    openSha256 = "sha256-NQg+QDm9Gt+5bapbUO96UFsPnz1hG1dtEwT/g/vKHkw=";
    settingsSha256 = "sha256-6n9mVkEL39wJj5FB1HBml7TTJhNAhS/j5hqpNGFQE4w=";
    persistencedSha256 = "sha256-dgmco+clEIY8bedxHC4wp+fH5JavTzyI1BI8BxoeJJI=";
  });

  # Vulkan developer beta driver
  # See here for more information: https://developer.nvidia.com/vulkan-driver
  vulkan_beta = generic rec {
    version = "570.123.18";
    persistencedVersion = "550.142";
    settingsVersion = "550.142";
    sha256_64bit = "sha256-GoBNatVpits13a3xsJSUr9BFG+5xrUDROfHmvss2cSY=";
    openSha256 = "sha256-AYl8En0ZAZXWlJ8J8LKbPvAEKX+y65L1aq4Hm+dJScs=";
    settingsSha256 = "sha256-Wk6IlVvs23cB4s0aMeZzSvbOQqB1RnxGMv3HkKBoIgY=";
    persistencedSha256 = "sha256-yQFrVk4i2dwReN0XoplkJ++iA1WFhnIkP7ns4ORmkFA=";
    url = "https://developer.nvidia.com/downloads/vulkan-beta-${lib.concatStrings (lib.splitVersion version)}-linux";

    broken = kernel.kernelAtLeast "6.15";
  };

  # data center driver compatible with current default cudaPackages
  dc = dc_565;

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

  # Update note:
  # If you add a legacy driver here, also update `top-level/linux-kernels.nix`,
  # adding to the `nvidia_x11_legacy*` entries.

  # Last one without the bug reported here:
  # https://bbs.archlinux.org/viewtopic.php?pid=2155426#p2155426
  legacy_535 = generic {
    version = "535.216.01";
    sha256_64bit = "sha256-Xd6hFHgQAS4zlnwxgTQbzWYkvT1lTGP4Rd+DO07Oavc=";
    sha256_aarch64 = "sha256-SGmuA0W1iSsqUK7VZsgibT4HgT0RkKpGb+ul6eIbM7k=";
    openSha256 = "sha256-ey96oMbY32ahcHSOj1+MykvJrep6mhHPVl+V8+B2ZDk=";
    settingsSha256 = "sha256-9PgaYJbP1s7hmKCYmkuLQ58nkTruhFdHAs4W84KQVME=";
    persistencedSha256 = "sha256-ckF/BgDA6xSFqFk07rn3HqXuR0iGfwA4PRxpP38QZgw=";
  };

  # Last one supporting Kepler architecture
  legacy_470 = generic {
    version = "470.256.02";
    sha256_64bit = "sha256-1kUYYt62lbsER/O3zWJo9z6BFowQ4sEFl/8/oBNJsd4=";
    sha256_aarch64 = "sha256-e+QvE+S3Fv3JRqC9ZyxTSiCu8gJdZXSz10gF/EN6DY0=";
    settingsSha256 = "sha256-kftQ4JB0iSlE8r/Ze/+UMnwLzn0nfQtqYXBj+t6Aguk=";
    persistencedSha256 = "sha256-iYoSib9VEdwjOPBP1+Hx5wCIMhW8q8cCHu9PULWfnyQ=";

    patches = [
      "${aurPatches}/gcc-14.patch"
      # fixes 6.10 follow_pfn
      ./follow_pfn.patch
      # https://gist.github.com/joanbm/a6d3f7f873a60dec0aa4a734c0f1d64e
      (fetchpatch {
        url = "https://gist.github.com/joanbm/a6d3f7f873a60dec0aa4a734c0f1d64e/raw/6bae5606c033b6c6c08233523091992370e357b7/nvidia-470xx-fix-linux-6.12.patch";
        hash = "sha256-6nbzcRTRCxW8GDAhB8Zwx9rVcCzwPtVYlqoUhL9gxlY=";
        stripLen = 1;
        extraPrefix = "kernel/";
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
    ];
    broken = kernel.kernelAtLeast "6.13";

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
