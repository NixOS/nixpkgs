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
  mkDriver = generic;

  # Official Unix Drivers - https://www.nvidia.com/en-us/drivers/unix/
  # Branch/Maturity data - http://people.freedesktop.org/~aplattner/nvidia-versions.txt

  # Policy: use the highest stable version as the default (on our master).
  stable = if stdenv.hostPlatform.system == "i686-linux" then legacy_390 else latest;

  production = generic {
    version = "535.146.02";
    sha256_64bit = "sha256-Sf0cyeRFyYspP3xm82vs/hLMwd6WDf/z8dyWujqcv3A=";
    sha256_aarch64 = "sha256-8G0oNdaVWxIGwVaQSw/cojy4TIAuiUBF3B98BI4hEec=";
    openSha256 = "sha256-Oyllcy3uYYK912CIusMwjKKHtMgoyOxpZWQQ8hIycuk=";
    settingsSha256 = "sha256-IrN2NaPrZSN0sCZqYNJ43iCicX3ziwUgyLLSRzp9sHQ=";
    persistencedSha256 = "sha256-trIddaTgKXszEJunK+t6D+e3HbLDTfAsitdEYRgwRNQ=";
  };

  latest = selectHighestVersion production (generic {
    version = "545.29.06";
    sha256_64bit = "sha256-grxVZ2rdQ0FsFG5wxiTI3GrxbMBMcjhoDFajDgBFsXs=";
    sha256_aarch64 = "sha256-o6ZSjM4gHcotFe+nhFTePPlXm0+RFf64dSIDt+RmeeQ=";
    openSha256 = "sha256-h4CxaU7EYvBYVbbdjiixBhKf096LyatU6/V6CeY9NKE=";
    settingsSha256 = "sha256-YBaKpRQWSdXG8Usev8s3GYHCPqL8PpJeF6gpa2droWY=";
    persistencedSha256 = "sha256-AiYrrOgMagIixu3Ss2rePdoL24CKORFvzgZY3jlNbwM=";

    patchFlags = [ "-p1" "-d" "kernel" ];
    patches = [];
  });

  beta = selectHighestVersion latest (generic {
    version = "545.23.06";
    sha256_64bit = "sha256-QTnTKAGfcvKvKHik0BgAemV3PrRqRlM3B9jjZeupCC8=";
    sha256_aarch64 = "sha256-qkVP6AiXNoRTqgqPvs/AfErEq8BTQw25rtJ6GS06JTM=";
    openSha256 = "sha256-m7D5LZdhFCZYAIbhrgZ0pN2z19LsU3I3Q7qsKX7Z6mM=";
    settingsSha256 = "sha256-+X6gDeU8Qlvprb05aB2quM55y0zEcBXtb65e3Rq9gKg=";
    persistencedSha256 = "sha256-RQJAIwPqOUI5FB3uf0/Y4K/iwFfoLpU1/+BOK/KF5VA=";
  });

  # Vulkan developer beta driver
  # See here for more information: https://developer.nvidia.com/vulkan-driver
  vulkan_beta = generic rec {
    version = "535.43.22";
    persistencedVersion = "535.98";
    settingsVersion = "535.98";
    sha256_64bit = "sha256-emam5bfYJeFi1+Z0Z1//luaY1JTKcQNYUP8GmG9480Q=";
    openSha256 = "sha256-8Nz6LfEdAsm7d6Leqs+ikN0BpOPkLCcd7bckK0MOIFU=";
    settingsSha256 = "sha256-jCRfeB1w6/dA27gaz6t5/Qo7On0zbAPIi74LYLel34s=";
    persistencedSha256 = "sha256-WviDU6B50YG8dO64CGvU3xK8WFUX8nvvVYm/fuGyroM=";
    url = "https://developer.nvidia.com/downloads/vulkan-beta-${lib.concatStrings (lib.splitVersion version)}-linux";
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

  dc_535 = generic rec {
    version = "535.129.03";
    url = "https://us.download.nvidia.com/tesla/${version}/NVIDIA-Linux-x86_64-${version}.run";
    sha256_64bit = "sha256-5tylYmomCMa7KgRs/LfBrzOLnpYafdkKwJu4oSb/AC4=";
    persistencedSha256 = "sha256-FRMqY5uAJzq3o+YdM2Mdjj8Df6/cuUUAnh52Ne4koME=";
    fabricmanagerSha256 = "sha256-5KRYS+JLVAhDkBn8Z7e0uJvULQy6dSpwnYsbBxw7Mxg=";
    useSettings = false;
    usePersistenced = true;
    useFabricmanager = true;
  };

  # Update note:
  # If you add a legacy driver here, also update `top-level/linux-kernels.nix`,
  # adding to the `nvidia_x11_legacy*` entries.

  # Last one supporting Kepler architecture
  legacy_470 = generic {
    version = "470.223.02";
    sha256_64bit = "sha256-s2hi1TNsw+br6Ow6tPiFsYPaJY8d+x4FrkBrP2xNRPg=";
    sha256_aarch64 = "sha256-CFkg2ARlGWqlFQKm8SlbwMH6eLidHKA/q5QGVOpPGuU=";
    settingsSha256 = "sha256-r6DuIH/rnsCm/y51iRgPNi5/kz+EFMVABREdTjBneZ0=";
    persistencedSha256 = "sha256-e71fpPBBv8S/aoeXxBXkzKy5bsMMbv8y024cSLc8DYc=";

    patchFlags = [ "-p1" "-d" "kernel" ];
    patches = [];
  };

  # Last one supporting x86
  legacy_390 = generic {
    version = "390.157";
    sha256_32bit = "sha256-VdZeCkU5qct5YgDF8Qgv4mP7CVHeqvlqnP/rioD3B5k=";
    sha256_64bit = "sha256-W+u8puj+1da52BBw+541HxjtxTSVJVPL3HHo/QubMoo=";
    settingsSha256 = "sha256-uJZO4ak/w/yeTQ9QdXJSiaURDLkevlI81de0q4PpFpw=";
    persistencedSha256 = "sha256-NuqUQbVt80gYTXgIcu0crAORfsj9BCRooyH3Gp1y1ns=";

    broken = kernel.kernelAtLeast "6.2";
  };

  legacy_340 = let
    # Source cooresponding to https://aur.archlinux.org/packages/nvidia-340xx-dkms
    aurPatches = fetchFromGitHub {
      owner = "archlinux-jerry";
      repo = "nvidia-340xx";
      rev = "fa434fb5da47e9423db2b19577817eb8c65d2f4e";
      hash = "sha256-KeMTYHGuZSAPGnYaERZSMu/4lWyB25ZCIv4nJhXxABY=";
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
    ];
  in generic {
    version = "340.108";
    sha256_32bit = "1jkwa1phf0x4sgw8pvr9d6krmmr3wkgwyygrxhdazwyr2bbalci0";
    sha256_64bit = "06xp6c0sa7v1b82gf0pq0i5p0vdhmm3v964v0ypw36y0nzqx8wf6";
    settingsSha256 = "0zm29jcf0mp1nykcravnzb5isypm8l8mg2gpsvwxipb7nk1ivy34";
    persistencedSha256 = "1ax4xn3nmxg1y6immq933cqzw6cj04x93saiasdc0kjlv0pvvnkn";
    useGLVND = false;

    broken = kernel.kernelAtLeast "6.6";
    patches = map (patch: "${aurPatches}/${patch}") patchset;
  };
}
