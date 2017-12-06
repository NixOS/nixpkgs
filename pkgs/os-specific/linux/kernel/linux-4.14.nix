{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

with stdenv.lib;

import ./generic.nix (args // rec {
  version = "4.14.4";

  # modDirVersion needs to be x.y.z, will automatically add .0 if needed
  modDirVersion = concatStrings (intersperse "." (take 3 (splitString "." "${version}.0")));

  # branchVersion needs to be x.y
  extraMeta.branch = concatStrings (intersperse "." (take 2 (splitString "." version)));

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "17m7ws3yp6f7ivi8n4gw0i10wf77bb37r7s6jbijg6nsj3vvz49a";
  };
} // (args.argsOverride or {}))
