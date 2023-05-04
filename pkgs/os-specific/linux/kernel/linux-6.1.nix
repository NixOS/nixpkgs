{ lib, buildPackages, fetchurl, perl, buildLinux, nixosTests, ... } @ args:

with lib;

buildLinux (args // rec {
  version = "6.1.27";

  # modDirVersion needs to be x.y.z, will automatically add .0 if needed
  modDirVersion = versions.pad 3 version;

  # branchVersion needs to be x.y
  extraMeta.branch = versions.majorMinor version;

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v6.x/linux-${version}.tar.xz";
    sha256 = "01grx5y48scyyihpj176knn5yvgpxv2gfkli03rwj31xvnb4pdy2";
  };
  # TODO: possible to remove after any rebuild, e.g. after update.
  extraConfig = lib.optionalString (buildPackages.stdenv.system == "x86_64-linux") "\n";
} // (args.argsOverride or { }))
