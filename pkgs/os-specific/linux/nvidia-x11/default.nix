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

  kernelModVersion = lib.versions.majorMinor kernel.modDirVersion;

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
    version = "515.76";
    sha256_64bit = "sha256-xqKhjOuWX0mAvOTlzqNv1iLNwaXzGg6xu9NZqen2v0Q=";
    openSha256 = "sha256-843l42atzaTm4pX5UC/JZjXAvhwmBpE8k3SQFEFdcdY=";
    settingsSha256 = "sha256-2GdqmuvROLa8xFfyFY/F4YzEBq+SlVIYM4CVEARh9MI=";
    persistencedSha256 = "sha256-nIfP7xBIVy+BUa9VBCNQ9v5RT4l4S9X0GHLpNiN/WRg=";

    brokenOpen = kernelModVersion == "5.4" && kernel.isHardened;
  };

  latest = selectHighestVersion production (generic {
    version = "520.56.06";
    sha256_64bit = "sha256-UWdLAL7Wdm7EPUHKhNGNaTkGI0+FUZBptqNB92wRPEY=";
    openSha256 = "sha256-miIxF/0fA7v8fU+oh/mx0DRqJdPBzmz14IqgPWJQeKU=";
    settingsSha256 = "sha256-NeT3tb7NGicKHnNkuOwbte6BJsP1bUzPSE+TXnevCAM=";
    persistencedSha256 = "sha256-3nWtnwpLaal3ty8GNMFa4zeonT8nKpYs6DIgsAq9+84=";
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
    version = "515.49.24";
    persistencedVersion = "515.48.07";
    settingsVersion = "515.48.07";
    sha256_64bit = "sha256-hiTG1gZr02hyetOGvHzY8Be9jaWklhteqe24BRvpw+c=";
    openSha256 = "sha256-4NFR4oY728E/yE3FoD3vph8NvSHGD0f0iK2FHqlgK94=";
    settingsSha256 = "sha256-XwdMsAAu5132x2ZHqjtFvcBJk6Dao7I86UksxrOkknU=";
    persistencedSha256 = "sha256-BTfYNDJKe4tOvV71/1JJSPltJua0Mx/RvDcWT5ccRRY=";
    url = "https://developer.nvidia.com/vulkan-beta-${lib.concatStrings (lib.splitString "." version)}-linux";

    broken = kernelModVersion == "5.4" && kernel.isHardened;
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

      broken = kernel.kernelAtLeast "6.0";
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
        (lib.optional (kernelModVersion == o.version) (fetchpatch {
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
