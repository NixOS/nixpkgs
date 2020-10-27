{ stdenv, buildPackages, fetchurl, perl, buildLinux, modDirVersionArg ? null, ... } @ args:

with stdenv.lib;

buildLinux (args // rec {
  version = "5.10-rc1";

  extraMeta = {
    branch = versions.majorMinor version;
    hydraPlatforms = [];
  } // (args.extraMeta or {});

  # modDirVersion needs to be x.y.z, will always add .0
  modDirVersion = if (modDirVersionArg == null) then builtins.replaceStrings ["-"] [".0-"] version else modDirVersionArg;

  src = fetchurl {
    url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
    sha256 = "1s4ywf93xrlkjjq3c4142qhmsvx3kl0xwkbc09ss6gln8lwqnga8";
  };

} // (args.argsOverride or {}))
