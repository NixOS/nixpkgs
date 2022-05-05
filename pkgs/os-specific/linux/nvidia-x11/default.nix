{ lib, callPackage, fetchpatch, fetchurl, stdenv, pkgsi686Linux }:

let
  generic = args: let
    imported = import ./generic.nix args;
  in if lib.versionAtLeast args.version "391"
    && stdenv.hostPlatform.system != "x86_64-linux" then null
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
      version = "510.68.02";
      sha256_64bit = "sha256-vSw0SskrL8ErBgQ1kKT+jU6wzLdNDEk1LwBM8tKZ9MU=";
      settingsSha256 = "sha256-4TBA/ITpaaBiVDkpj7/Iydei1knRPpruPL4fRrqFAmU=";
      persistencedSha256 = "sha256-Q1Rk6dAK4pnm6yDK4kmj5Vg4GRbi034C96ypywHYB2I=";
    }
    else legacy_390;

  # see https://www.nvidia.com/en-us/drivers/unix/ "Production branch"
  production = legacy_470;

  beta = generic {
    version = "510.39.01";
    sha256_64bit = "sha256-Lj7cOvulhApeuRycIiyYy5kcPv3ZlM8qqpPUWl0bmRs=";
    settingsSha256 = "sha256-qlSwNq0wC/twvrbQjY+wSTcDaV5KG4Raq6WkzTizyXw=";
    persistencedSha256 = "sha256-UNrl/hfiNXKGACQ7aHpsNcfcHPWVnycQ51yaa3eKXhI=";
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
  };

  # Update note:
  # If you add a legacy driver here, also update `top-level/linux-kernels.nix`,
  # adding to the `nvidia_x11_legacy*` entries.

  # Last one supporting Kepler architecture
  legacy_470 = generic {
      version = "470.103.01";
      sha256_64bit = "VsIwn4nCE0Y7DEY2D3siddc3HTxyevP+3IjElu3Ih6U=";
      settingsSha256 = "Roc2OFSNEnIGLVwP0D9f8vFTf5v3KkL99S0mZBWN7s0=";
      persistencedSha256 = "AVI0j2bpfMCMBTKuQp+BoCewaXIW3Xt4NnV1fjAHOr0=";
  };

  # Last one supporting x86
  legacy_390 = generic {
    version = "390.147";
    sha256_32bit = "00avsns7l0j1ai8bf8gav2qshvphfdngy388bwzz24p61mfv1i1a";
    sha256_64bit = "09qcdfn4j5jza3iw59wqwgq4a489qf7kx355yssrcahaw9g87lxz";
    settingsSha256 = "16qqw0jy31da65cdi17y3j2kcdhw09vra7g17bkcimaqnf70j0ni";
    persistencedSha256 = "1ad81y4qfpxrx0vqsk81a3h0bi1yg8hw5gi5y5d58p76vc8083i9";

    broken = kernel.kernelAtLeast "5.17";
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
