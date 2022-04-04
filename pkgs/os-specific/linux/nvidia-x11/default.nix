{ lib, callPackage, fetchpatch, fetchurl, stdenv, pkgsi686Linux }:

let
  generic = args: let
    imported = import ./generic.nix args;
  in if ((!lib.versionOlder args.version "391")
    && stdenv.hostPlatform.system != "x86_64-linux") then null
  else callPackage imported {
    lib32 = (pkgsi686Linux.callPackage imported {
      libsOnly = true;
      kernel = null;
    }).out;
  };

  kernel = callPackage # a hacky way of extracting parameters from callPackage
    ({ kernel, libsOnly ? false }: if libsOnly then { } else kernel) { };
in
rec {
  # Policy: use the highest stable version as the default (on our master).
  stable = if stdenv.hostPlatform.system == "x86_64-linux"
    then generic {
      version = "510.60.02";
      sha256_64bit = "sha256-qADfwFSQeP2Mbo5ngO+47uh4cuYFXH9fOGpHaM4H4AM=";
      settingsSha256 = "sha256-Voa1JZ2qqJ1t+bfwKh/mssEi/hjzLTPwef2XG/gAC+0=";
      persistencedSha256 = "sha256-THgK2GpRcttqSN2WxcuJu5My++Q+Y34jG8hm7daxhAQ=";
    }
    else legacy_390;

  beta = generic {
    version = "510.39.01";
    sha256_64bit = "sha256-Lj7cOvulhApeuRycIiyYy5kcPv3ZlM8qqpPUWl0bmRs=";
    settingsSha256 = "sha256-qlSwNq0wC/twvrbQjY+wSTcDaV5KG4Raq6WkzTizyXw=";
    persistencedSha256 = "sha256-UNrl/hfiNXKGACQ7aHpsNcfcHPWVnycQ51yaa3eKXhI=";
  };

  # Vulkan developer beta driver
  # See here for more information: https://developer.nvidia.com/vulkan-driver
  vulkan_beta = generic rec {
    version = "455.46.04";
    persistencedVersion = "455.45.01";
    settingsVersion = "455.45.01";
    sha256_64bit = "1iv42w3x1vc00bgn6y4w1hnfsvnh6bvj3vcrq8hw47760sqwa4xa";
    settingsSha256 = "09v86y2c8xas9ql0bqr7vrjxx3if6javccwjzyly11dzffm02h7g";
    persistencedSha256 = "13s4b73il0lq2hs81q03176n16mng737bfsp3bxnxgnrv3whrayz";
    url = "https://developer.nvidia.com/vulkan-beta-${lib.concatStrings (lib.splitString "." version)}-linux";
  };

  # Update note:
  # If you add a legacy driver here, also update `top-level/linux-kernels.nix`,
  # adding to the `nvidia_x11_legacy*` entries.

  # Last one supporting Kepler architecture
  legacy_470 = generic {
      version = "470.86";
      sha256_64bit = "sha256:0krwcxc0j19vjnk8sv6mx1lin2rm8hcfhc2hg266846jvcws1dsg";
      settingsSha256 = "sha256:1lnj5hwmfkzs664fxlhljqy323394s1i7qzlpsjyrpm07sa93bky";
      persistencedSha256 = "sha256:0apj764zc81ayb8nm9bf7cdicfinarv0gfijy2dxynbwz2xdlyvq";
  };

  # Last one supporting x86
  legacy_390 = generic {
    version = "390.143";
    sha256_32bit = "AelrdTTeo/3+ZdXK0iniZDB8gJUkeZQtNoRm25z+bQY=";
    sha256_64bit = "tyKqcPM71ErK8ZZHLPtxmgrWzv6tfEmxBRveCSwTlO8=";
    settingsSha256 = "EJPXZbxZS1CMENAYk9dCAIsHsRTXJpj473+JLuhGkWI=";
    persistencedSha256 = "FtlPF3jCNr18NnImTmr8zJsaK9wbj/aWZ9LwoLr5SeE=";
  };

  legacy_340 = generic {
    version = "340.108";
    sha256_32bit = "1jkwa1phf0x4sgw8pvr9d6krmmr3wkgwyygrxhdazwyr2bbalci0";
    sha256_64bit = "06xp6c0sa7v1b82gf0pq0i5p0vdhmm3v964v0ypw36y0nzqx8wf6";
    settingsSha256 = "0zm29jcf0mp1nykcravnzb5isypm8l8mg2gpsvwxipb7nk1ivy34";
    persistencedSha256 = "1ax4xn3nmxg1y6immq933cqzw6cj04x93saiasdc0kjlv0pvvnkn";
    useGLVND = false;

    patches = [ ./vm_operations_struct-fault.patch ];
  };
}
