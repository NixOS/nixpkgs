{ stdenv, buildPackages, hostPlatform, fetchFromGitHub, perl, buildLinux, ... } @ args:

with stdenv.lib;

let
  version = "4.15.10";
  revision = "a";
  sha256 = "02plwrj6d7wzwf6w8q2cxspy2q58i3v46clm2vf8m9x6mm88jrzx";

  # modVersion needs to be x.y.z, will automatically add .0 if needed
  modVersion = concatStrings (intersperse "." (take 3 (splitString "." "${version}.0")));

  # branchVersion needs to be x.y
  branchVersion = concatStrings (intersperse "." (take 2 (splitString "." version)));

  modDirVersion = "${modVersion}-hardened";
in
buildLinux (args // {
  inherit modDirVersion;

  version = "${version}-${revision}";
  extraMeta.branch = "${branchVersion}";

  src = fetchFromGitHub {
    inherit sha256;
    owner = "copperhead";
    repo = "linux-hardened";
    rev = "${version}.${revision}";
  };
} // (args.argsOverride or {}))
