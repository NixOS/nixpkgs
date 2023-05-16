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
<<<<<<< HEAD
  mkDriver = generic;

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  # Official Unix Drivers - https://www.nvidia.com/en-us/drivers/unix/
  # Branch/Maturity data - http://people.freedesktop.org/~aplattner/nvidia-versions.txt

  # Policy: use the highest stable version as the default (on our master).
  stable = if stdenv.hostPlatform.system == "i686-linux" then legacy_390 else latest;

  production = generic {
<<<<<<< HEAD
    version = "535.104.05";
    sha256_64bit = "sha256-L51gnR2ncL7udXY2Y1xG5+2CU63oh7h8elSC4z/L7ck=";
    sha256_aarch64 = "sha256-J4uEQQ5WK50rVTI2JysBBHLpmBEWQcQ0CihgEM6xuvk=";
    openSha256 = "sha256-0ng4hyiUt0rHZkNveFTo+dSaqkMFO4UPXh85/js9Zbw=";
    settingsSha256 = "sha256-pS9W5LMenX0Rrwmpg1cszmpAYPt0Mx+apVQmOmLWTog=";
    persistencedSha256 = "sha256-uqT++w0gZRNbzyqbvP3GBqgb4g18r6VM3O8AMEfM7GU=";
=======
    version = "525.116.04";
    sha256_64bit = "sha256-hhDsgkR8/3LLXxizZX7ppjSlFRZiuK2QHrgfTE+2F/4=";
    sha256_aarch64 = "sha256-k7k22z5PYZdBVfuYXVcl9SFUMqZmK4qyxoRwlYyRdgU=";
    openSha256 = "sha256-dktHCoESqoNfu5M73aY5MQGROlZawZwzBqs3RkOyfoQ=";
    settingsSha256 = "sha256-qNjfsT9NGV151EHnG4fgBonVFSKc4yFEVomtXg9uYD4=";
    persistencedSha256 = "sha256-ci86XGlno6DbHw6rkVSzBpopaapfJvk0+lHcR4LDq50=";

    ibtSupport = true;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  latest = selectHighestVersion production (generic {
    version = "530.41.03";
    sha256_64bit = "sha256-riehapaMhVA/XRYd2jQ8FgJhKwJfSu4V+S4uoKy3hLE=";
    sha256_aarch64 = "sha256-uM5zMEO/AO32VmqUOzmc05FFm/lz76jPSSaQmeZUlFo=";
    openSha256 = "sha256-etbtw6LMRUcFoZC9EDDRrTDekV8JFRYmkp3idLaMk5g=";
    settingsSha256 = "sha256-8KB6T9f+gWl8Ni+uOyrJKiiH5mNx9eyfCcW/RjPTQQA=";
    persistencedSha256 = "sha256-zrstlt/0YVGnsPGUuBbR9ULutywi2wNDVxh7OhJM7tM=";
<<<<<<< HEAD

    patchFlags = [ "-p1" "-d" "kernel" ];
    patches = [
      # source: https://gist.github.com/joanbm/77f0650d45747b9a4dc8e330ade2bf5c
      (fetchpatch {
        url = "https://gist.github.com/joanbm/77f0650d45747b9a4dc8e330ade2bf5c/raw/688b612624945926676de28059fe749203b4b549/nvidia-470xx-fix-linux-6.4.patch";
        hash = "sha256-OyRmezyzqAi7mSJHDjsWQVocSsgJPTW5DvHDFVNX7Dk=";
      })
    ];
  });

  beta = selectHighestVersion latest (generic {
    version = "535.43.02";
    sha256_64bit = "sha256-4KTdk4kGDmBGyHntMIzWRivUpEpzmra+p7RBsTL8mYM=";
    sha256_aarch64 = "sha256-0blD8R+xpOVlitWefIbtw1d3KAnmWHBy7hkxGZHBrE4=";
    openSha256 = "sha256-W1fwbbEEM7Z/S3J0djxGTtVTewbSALqX1G1OSpdajCM=";
    settingsSha256 = "sha256-j0sSEbtF2fapv4GSthVTkmJga+ycmrGc1OnGpV6jEkc=";
    persistencedSha256 = "sha256-M0ovNaJo8SZwLW4CQz9accNK79Z5JtTJ9kKwOzicRZ4=";
=======
  });

  beta = selectHighestVersion latest (generic {
    version = "530.30.02";
    sha256_64bit = "sha256-R/3bvXoiumYZI9vObn9R7sVN9oBQxAbMBJDDv77eeWM=";
    sha256_aarch64 = "sha256-/b5Jdow+O7ExXjtXTzDX38qgmBDUYDUl+5zxXvbi1ts=";
    openSha256 = "sha256-LCtTyuJ8s8isTBt9HetItLqSjL1GOn0tPUarjuxHpMk=";
    settingsSha256 = "sha256-6mynLNSaWeiB52HdwZ0EQNyPg+tuat0oEqpZGSb2yQo=";
    persistencedSha256 = "sha256-h6iq0iD9F41a7s6jWKPTI+oVzgDRIr1Kk97LNH9rg7E=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  });

  # Vulkan developer beta driver
  # See here for more information: https://developer.nvidia.com/vulkan-driver
  vulkan_beta = generic rec {
<<<<<<< HEAD
    version = "535.43.09";
    persistencedVersion = "535.98";
    settingsVersion = "535.98";
    sha256_64bit = "sha256-7QDp+VDgxH7RGW40kbQp4F/luh0DCYb4BS0gU/6wn+c=";
    openSha256 = "sha256-7MOwKQCTaOo1//8OlSaNdpKeDXejZvmKFFeqhFrhAk8=";
    settingsSha256 = "sha256-jCRfeB1w6/dA27gaz6t5/Qo7On0zbAPIi74LYLel34s=";
    persistencedSha256 = "sha256-WviDU6B50YG8dO64CGvU3xK8WFUX8nvvVYm/fuGyroM=";
    url = "https://developer.nvidia.com/downloads/vulkan-beta-${lib.concatStrings (lib.splitString "." version)}-linux";
  };

  # data center driver compatible with current default cudaPackages
  dc = dc_520;
  dc_520 = generic rec {
    version = "520.61.05";
    url = "https://us.download.nvidia.com/tesla/${version}/NVIDIA-Linux-x86_64-${version}.run";
    sha256_64bit = "sha256-EPYWZwOur/6iN/otDMrNDpNXr1mzu8cIqQl8lXhQlzU==";
    fabricmanagerSha256 = "sha256-o8Kbmkg7qczKQclaGvEyXNzEOWq9ZpQZn9syeffnEiE==";
    useSettings = false;
    usePersistenced = false;
    useFabricmanager = true;
  };

=======
    version = "525.47.22";
    persistencedVersion = "525.85.05";
    settingsVersion = "525.85.05";
    sha256_64bit = "sha256-y8XgeGljiR2q/Wzp2btCQ8Wa+9KvWsWxZHb+NIqfCYQ=";
    openSha256 = "sha256-Y8XL8BJWSV2K1p4VR8T9Z2DOqySgQqkB4Dvf6E6vcxI=";
    settingsSha256 = "sha256-ck6ra8y8nn5kA3L9/VcRR2W2RaWvfVbgBiOh2dRJr/8=";
    persistencedSha256 = "sha256-dt/Tqxp7ZfnbLel9BavjWDoEdLJvdJRwFjTFOBYYKLI=";
    url = "https://developer.nvidia.com/downloads/vulkan-beta-${lib.concatStrings (lib.splitString "." version)}-linux";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  # Update note:
  # If you add a legacy driver here, also update `top-level/linux-kernels.nix`,
  # adding to the `nvidia_x11_legacy*` entries.

  # Last one supporting Kepler architecture
  legacy_470 = generic {
<<<<<<< HEAD
    version = "470.199.02";
    sha256_64bit = "sha256-/fggDt8RzjLDW0JiGjr4aV4RGnfEKL8MTTQ4tCjXaP0=";
    sha256_aarch64 = "sha256-UmF7LszdrO2d+bOaoQYrTVKXUwDqzMy1UDBW5SPuZy4=";
    settingsSha256 = "sha256-FkKPE4QV5IiVizGYUNUYoEXRpEhojt/cbH/I8iCn3hw=";
    persistencedSha256 = "sha256-JP71wt3uCNOgheLNlQbW3DqVFQNTC5vj4y4COWKQzAs=";

    patchFlags = [ "-p1" "-d" "kernel" ];
    patches = [
      # source: https://gist.github.com/joanbm/dfe8dc59af1c83e2530a1376b77be8ba
      (fetchpatch {
        url = "https://gist.github.com/joanbm/dfe8dc59af1c83e2530a1376b77be8ba/raw/37ff2b5ccf99f295ff958c9a44ca4ed4f42503b4/nvidia-470xx-fix-linux-6.5.patch";
        hash = "sha256-s5r7nwuMva0BLy2qJBVKqNtnUN9am5+PptnVwNdzdbk=";
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD

    broken = kernel.kernelAtLeast "6.2";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  legacy_340 = let
    # Source cooresponding to https://aur.archlinux.org/packages/nvidia-340xx-dkms
    aurPatches = fetchFromGitHub {
      owner = "archlinux-jerry";
      repo = "nvidia-340xx";
<<<<<<< HEAD
      rev = "f472f9297fe2ae285b954cd3f88abd8e2e255e4f";
      hash = "sha256-tMA69Wlhi14DMS3O3nfwMX3EiT8pKa6McLxFpAayoEI=";
=======
      rev = "fe2b38e66f2199777bcede6eb35c5df0210f15dc";
      hash = "sha256-hPFfzWGo2jF/DLm1OkP+BBnRY69N8kKUZ1EGkoHJlKA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
      "0012-kernel-6.2.patch"
      "0013-kernel-6.3.patch"
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    ];
  in generic {
    version = "340.108";
    sha256_32bit = "1jkwa1phf0x4sgw8pvr9d6krmmr3wkgwyygrxhdazwyr2bbalci0";
    sha256_64bit = "06xp6c0sa7v1b82gf0pq0i5p0vdhmm3v964v0ypw36y0nzqx8wf6";
    settingsSha256 = "0zm29jcf0mp1nykcravnzb5isypm8l8mg2gpsvwxipb7nk1ivy34";
    persistencedSha256 = "1ax4xn3nmxg1y6immq933cqzw6cj04x93saiasdc0kjlv0pvvnkn";
    useGLVND = false;

<<<<<<< HEAD
    broken = kernel.kernelAtLeast "6.4";
=======
    broken = kernel.kernelAtLeast "6.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    patches = map (patch: "${aurPatches}/${patch}") patchset;
  };
}
