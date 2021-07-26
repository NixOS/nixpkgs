{ lib, buildPackages, fetchurl, perl, buildLinux, nixosTests, modDirVersionArg ? null, ... } @ args:

with lib;

buildLinux (args // rec {
  version = "5.14-rc3";

  # modDirVersion needs to be x.y.z, will always add .0
  modDirVersion = if (modDirVersionArg == null) then builtins.replaceStrings [ "-" ] [ ".0-" ] version else modDirVersionArg;

  src = fetchurl {
    url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
    sha256 = "sha256-pdu3cMS1+delgQD8V3OFYy0FGTMrRfAWmwIGl9ntsc4=";
  };

  kernelTests = args.kernelTests or [ nixosTests.kernel-generic.linux_testing ];

  # Should the testing kernels ever be built on Hydra?
  extraMeta = {
    hydraPlatforms = [ ];
    branch = versions.majorMinor version;
  };

} // (args.argsOverride or { }))
