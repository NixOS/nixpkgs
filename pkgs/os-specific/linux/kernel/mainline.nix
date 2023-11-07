{ branch, lib, fetchurl, fetchzip, buildLinux, ... } @ args:

let
  allKernels = builtins.fromJSON (builtins.readFile ./kernels-org.json);
  thisKernel = allKernels.${branch};
  inherit (thisKernel) version;

  src =
    # -next and testing kernels are a special case because they don't have tarballs on the CDN
    if lib.hasPrefix "next-" branch
      then fetchzip {
        url = "https://git.kernel.org/next/linux-next/t/linux-next-${branch}.tar.gz";
        inherit (thisKernel) hash;
      }
    else if branch == "testing"
      then fetchzip {
        url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
        inherit (thisKernel) hash;
      }
      else fetchurl {
        url = "mirror://kernel/linux/kernel/v${lib.versions.major version}.x/linux-${version}.tar.xz";
        inherit (thisKernel) hash;
      };

  args' = (builtins.removeAttrs args ["branch"]) // {
    inherit src version;

    modDirVersion =
      lib.versions.pad 3 version
      + lib.optionalString (lib.hasPrefix "next-" branch)
        "-${branch}";
    extraMeta.branch = branch;
  } // (args.argsOverride or {});
in
buildLinux args'
