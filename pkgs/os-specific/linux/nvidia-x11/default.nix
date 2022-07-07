{ lib, callPackage, fetchpatch, fetchurl, stdenv, pkgsi686Linux }:

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
in
rec {
  # Policy: use the highest stable version as the default (on our master).
  stable = if stdenv.hostPlatform.system == "x86_64-linux"
    then generic {
      version = "515.57";
      sha256_64bit = "sha256-hB1p/hQmiDZHESuwcP4vKaH4ScZKyAqNYccJcNjT1SI=";
      openSha256 = "sha256-D8fXlmuGEHkFAT2aSAj7hXpndi2bfOd6vQAcKfsQx4U=";
      settingsSha256 = "sha256-M9AVeMsHSQv+zhIdBtXm+QRXf7NcZpLfCDmKMUjBl1U=";
      persistencedSha256 = "sha256-joKUuP4PgQxu4kOxy8SkHORPkEmuYfk3b+7svAyMQ1Q=";
    }
    else legacy_390;

  # see https://www.nvidia.com/en-us/drivers/unix/ "Production branch"
  production = stable;

  beta = generic {
    version = "515.43.04";
    sha256_64bit = "sha256-PodaTTUOSyMW8rtdtabIkSLskgzAymQyfToNlwxPPcc=";
    openSha256 = "sha256-1bAr5dWZ4jnY3Uo2JaEz/rhw2HuW9LZ5bACmA1VG068=";
    settingsSha256 = "sha256-j47LtP6FNTPfiXFh9KwXX8vZOQzlytA30ZfW9N5F2PY=";
    persistencedSha256 = "sha256-hULBy0wnVpLH8I0L6O9/HfgvJURtE2whpXOgN/vb3Wo=";
  };

  # Vulkan developer beta driver
  # See here for more information: https://developer.nvidia.com/vulkan-driver
  vulkan_beta = generic rec {
    version = "470.62.13";
    persistencedVersion = "470.86";
    settingsVersion = "470.86";
    sha256_64bit = "sha256-itBFNPMy+Nn0g8V8qdkRb+ELHj57GRso1lXhPHUxKVI=";
    settingsSha256 = "sha256-fq6RlD6g3uylvvTjE4MmaQwxPJYU0u6IMfpPVzks0tI=";
    persistencedSha256 = "sha256-eHvauvh8Wd+b8DK6B3ZWNjoWGztupWrR8iog9ok58io=";
    url = "https://developer.nvidia.com/vulkan-beta-${lib.concatStrings (lib.splitString "." version)}-linux";
    broken = kernel.kernelAtLeast "5.17";
  };

  # Update note:
  # If you add a legacy driver here, also update `top-level/linux-kernels.nix`,
  # adding to the `nvidia_x11_legacy*` entries.

  # Last one supporting Kepler architecture
  legacy_470 = generic {
      version = "470.129.06";
      sha256_64bit = "sha256-QQkQtwBuFzBjMnaDKfS1PW+ekcxVXCiJkXWOKo8IqZg=";
      settingsSha256 = "sha256-vUS4O/c4IrbC8offzUFGLlMdP/Tlz1GwQIV2geRfj/o=";
      persistencedSha256 = "sha256-jCcYUsbhQ77IOQquXqbTZfh1N0IvKQOWrIMU9rEwSW0=";
  };

  # Last one supporting x86
  legacy_390 = generic {
    version = "390.151";
    sha256_32bit = "sha256-lOOZtFllnBKxNE6Mj09e7h7VkV/0WfyLuDHJ4dRGd9s=";
    sha256_64bit = "sha256-UibkhCBEz/2Qlt6tr2iTTBM9p04FuAzNISNlhLOvsfw=";
    settingsSha256 = "sha256-teXQa0pQctQl1dvddVJtI7U/vVuMu6ER1Xd99Jprpvw=";
    persistencedSha256 = "sha256-FxiTXYABplKFcBXr4orhYWiJq4zVePpplMbg2kvEuXk=";
  };

  legacy_340 = generic {
    version = "340.108";
    sha256_32bit = "1jkwa1phf0x4sgw8pvr9d6krmmr3wkgwyygrxhdazwyr2bbalci0";
    sha256_64bit = "06xp6c0sa7v1b82gf0pq0i5p0vdhmm3v964v0ypw36y0nzqx8wf6";
    settingsSha256 = "0zm29jcf0mp1nykcravnzb5isypm8l8mg2gpsvwxipb7nk1ivy34";
    persistencedSha256 = "1ax4xn3nmxg1y6immq933cqzw6cj04x93saiasdc0kjlv0pvvnkn";
    useGLVND = false;

    broken = kernel.kernelAtLeast "5.5";
    patches = [ ./vm_operations_struct-fault.patch ];
  };
}
