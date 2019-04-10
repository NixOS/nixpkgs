{ stdenv, buildPackages, fetchurl, perl, buildLinux, modDirVersionArg ? null, ... } @ args:

with stdenv.lib;

buildLinux (args // rec {
  version = "4.14.0-ck1";

  # modDirVersion needs to be x.y.z, will automatically add .0 if needed

  # branchVersion needs to be x.y
  extraMeta.branch = concatStrings (intersperse "." (take 2 (splitString "." version)));

  src = args.fetchFromGitHub {
    owner  = "ckolivas";
    repo   = "linux";
    rev    = "4.14-ck";
    sha256 = "12v1y4rld79pwc7nfg1sq2sh0xphsl5bd54iklj2qhk4h19z46iy";
  };
} // (args.argsOverride or {}))

