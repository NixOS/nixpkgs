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
    version = "525.85.05";
    sha256_64bit = "sha256-6mO0JTQDsiS7cxOol3qSDf6dID1mHdX2/CZYWnAXkUA=";
    openSha256 = "sha256-iI41eex/pQhWdQwk9qc9AlnVYcO0HRA9ISoqNdVKN7g=";
    settingsSha256 = "sha256-ck6ra8y8nn5kA3L9/VcRR2W2RaWvfVbgBiOh2dRJr/8=";
    persistencedSha256 = "sha256-dt/Tqxp7ZfnbLel9BavjWDoEdLJvdJRwFjTFOBYYKLI=";
  };

  latest = selectHighestVersion production (generic {
    version = "520.56.06";
    sha256_64bit = "sha256-UWdLAL7Wdm7EPUHKhNGNaTkGI0+FUZBptqNB92wRPEY=";
    openSha256 = "sha256-miIxF/0fA7v8fU+oh/mx0DRqJdPBzmz14IqgPWJQeKU=";
    settingsSha256 = "sha256-NeT3tb7NGicKHnNkuOwbte6BJsP1bUzPSE+TXnevCAM=";
    persistencedSha256 = "sha256-3nWtnwpLaal3ty8GNMFa4zeonT8nKpYs6DIgsAq9+84=";
  });

  beta = selectHighestVersion latest (generic {
    version = "525.53";
    sha256_64bit = "sha256-dLsJcfBPHd3TxGQciRcG+5bo3lLiL2B55Q3nbTpRaH8=";
    openSha256 = "sha256-XA5RY+dQZv+dTHF7rm/bXnPZLj1G75PJKSTfREpuKag=";
    settingsSha256 = "sha256-N3+EOm2D2NSmD/cai+Pm2z5WHmV+GEJVr9KTQv/7j88=";
    persistencedSha256 = "sha256-AhB6zetbejQzajg76+hqpbfv3OzftueXGpviepH/xss=";
  });

  # Vulkan developer beta driver
  # See here for more information: https://developer.nvidia.com/vulkan-driver
  vulkan_beta = generic rec {
    version = "525.47.06";
    persistencedVersion = "525.85.05";
    settingsVersion = "525.85.05";
    sha256_64bit = "sha256-HxRXtd3ubjS1V/y1hDWe16XNSCbQYHoEw+Jz8Emy5/4=";
    openSha256 = "sha256-oiOlCdkFMXm4vVZzmnnI5/INVWUqC02gGj/aIfzjGig=";
    settingsSha256 = "sha256-ck6ra8y8nn5kA3L9/VcRR2W2RaWvfVbgBiOh2dRJr/8=";
    persistencedSha256 = "sha256-dt/Tqxp7ZfnbLel9BavjWDoEdLJvdJRwFjTFOBYYKLI=";
    url = "https://developer.nvidia.com/downloads/vulkan-beta-${lib.concatStrings (lib.splitString "." version)}-linux";
  };

  # Update note:
  # If you add a legacy driver here, also update `top-level/linux-kernels.nix`,
  # adding to the `nvidia_x11_legacy*` entries.

  # Last one supporting Kepler architecture
  legacy_470 = generic {
    version = "470.161.03";
    sha256_64bit = "sha256-Xagqf4x254Hn1/C+e3mNtNNE8mvU+s+avPPHHHH+dkA=";
    settingsSha256 = "sha256-ryUSiI8PsY3knkJLg0k1EmyYW5OWkhuZma/hmXNuojw=";
    persistencedSha256 = "sha256-/2h90Gq9NQd9Q+9eLVE6vrxXmINXxlLcSNOHxKToOEE=";
  };

  # Last one supporting x86
  legacy_390 = generic {
    version = "390.157";
    sha256_32bit = "sha256-VdZeCkU5qct5YgDF8Qgv4mP7CVHeqvlqnP/rioD3B5k=";
    sha256_64bit = "sha256-W+u8puj+1da52BBw+541HxjtxTSVJVPL3HHo/QubMoo=";
    settingsSha256 = "sha256-uJZO4ak/w/yeTQ9QdXJSiaURDLkevlI81de0q4PpFpw=";
    persistencedSha256 = "sha256-NuqUQbVt80gYTXgIcu0crAORfsj9BCRooyH3Gp1y1ns=";
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
