{ branch, lib, fetchurl, buildLinux, ... } @ args:

let
  allKernels = builtins.fromJSON (builtins.readFile ./kernels-org.json);
  thisKernel = allKernels.${branch};

  args' = (builtins.removeAttrs args ["branch"]) // rec {
    inherit (thisKernel) version;
    modDirVersion = lib.versions.pad 3 version;
    extraMeta.branch = branch;

    src = fetchurl {
      url = "mirror://kernel/linux/kernel/v${lib.versions.major version}.x/linux-${version}.tar.xz";
      sha256 = thisKernel.hash;
    };
  } // (args.argsOverride or {});
in
buildLinux args'
