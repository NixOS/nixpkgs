{ stdenv, buildPackages, hostPlatform, fetchFromGitHub, perl, buildLinux, ... } @ args:

with stdenv.lib;

let
  version = "4.15.4";
  revision = "a";
  sha256 = "0j7nla8vjrxr82nfx8dl34qk8b56piwqbndqch9rv7plgl30hkj7";

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
