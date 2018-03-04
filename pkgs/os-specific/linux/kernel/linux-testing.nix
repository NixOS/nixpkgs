{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, libelf, utillinux, ... } @ args:

buildLinux (args // rec {
  version = "4.16-rc3";
  modDirVersion = "4.16.0-rc3";
  extraMeta.branch = "4.16";

  src = fetchurl {
    url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
    sha256 = "1av2fki8dxcxmm3p8w25njij0akv33ylzf10g8gi7f1qshmlysdp";
  };

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
