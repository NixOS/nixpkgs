let
  allKernels = builtins.fromJSON (builtins.readFile ./kernels-org.json);
in

{ branch, lib, fetchurl, fetchzip, buildLinux, ... } @ args:

let
  thisKernel = allKernels.${branch};
  inherit (thisKernel) version;

  src =
    # testing kernels are a special case because they don't have tarballs on the CDN
    if branch == "testing"
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

    modDirVersion = lib.versions.pad 3 version;
    extraMeta.branch = branch;
  } // (args.argsOverride or {});
in
buildLinux args'
