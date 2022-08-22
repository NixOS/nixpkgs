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
    version = "515.65.01";
    sha256_64bit = "sha256-BJLdxbXmWqAMvHYujWaAIFyNCOEDtxMQh6FRJq7klek=";
    openSha256 = "sha256-GCCDnaDsbXTmbCYZBCM3fpHmOSWti/DkBJwYrRGAMPI=";
    settingsSha256 = "sha256-kBELMJCIWD9peZba14wfCoxsi3UXO3ehFYcVh4nvzVg=";
    persistencedSha256 = "sha256-P8oT7g944HvNk2Ot/0T0sJM7dZs+e0d+KwbwRrmsuDY=";
  };

  latest = selectHighestVersion production (generic {
    version = "495.46";
    sha256_64bit = "2Dt30X2gxUZnqlsT1uqVpcUTBCV7Hs8vjUo7WuMcYvU=";
    settingsSha256 = "vbcZYn+UBBGwjfrJ6SyXt3+JLBeNcXK4h8mjj7qxZPk=";
    persistencedSha256 = "ieYqkVxe26cLw1LUgBsFSSowAyfZkTcItIzQCestCXI=";
  });

  beta = selectHighestVersion latest (generic {
    version = "515.43.04";
    sha256_64bit = "sha256-PodaTTUOSyMW8rtdtabIkSLskgzAymQyfToNlwxPPcc=";
    openSha256 = "sha256-1bAr5dWZ4jnY3Uo2JaEz/rhw2HuW9LZ5bACmA1VG068=";
    settingsSha256 = "sha256-j47LtP6FNTPfiXFh9KwXX8vZOQzlytA30ZfW9N5F2PY=";
    persistencedSha256 = "sha256-hULBy0wnVpLH8I0L6O9/HfgvJURtE2whpXOgN/vb3Wo=";
  });

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
      version = "470.141.03";
      sha256_64bit = "sha256-vpjSR6Q9dJGmW/3Jl/tlMeFZQ0brEqD6qgRGcs21cJ8=";
      settingsSha256 = "sha256-OWSUmUBqAxsR3e6EPzcIotpd6nm4Le8hIj4pzJ5WnhE=";
      persistencedSha256 = "sha256-XsGYGgucDhvPpqtM9IBLfo3tbn7sIobpo5JW/XqOkTo=";
  };

  # Last one supporting x86
  legacy_390 = generic {
    version = "390.154";
    sha256_32bit = "sha256-XuhxuEvZ8o4iW3o+Xxvh+eLQBn83uNa40MJRcC8G0+c=";
    sha256_64bit = "sha256-9EICgMVSEJZMAI1bck8mFYRdR61MnAXY7SamL8YzH3w=";
    settingsSha256 = "sha256-iNT6//EvtasivDfXPY6j6OrpymbslO/q45uKd5smFUw=";
    persistencedSha256 = "sha256-y+MkudjQBkuVzHrY/rh7IGRN8VjLsJQ3a+fYDXdrzzk=";

    broken = kernel.kernelAtLeast "5.18";

    patches =
      let patch390 = o:
        (lib.optional ((lib.versions.majorMinor kernel.modDirVersion) == o.version) (fetchpatch {
          inherit (o) sha256;
          url = "https://gitlab.com/herecura/packages/nvidia-390xx-dkms/-/raw/herecura/kernel-${o.version}.patch";
        }));
      in
        []
        ++ (patch390 {
          version = "5.18";
          sha256 = "sha256-A6itoozgDWmXKQAU0D8bT2vUaZqh5G5Tg3d3E+CLOTs=";
        })
      ;
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
