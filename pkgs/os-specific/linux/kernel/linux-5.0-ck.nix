{ stdenv, buildPackages, fetchFromGitHub, perl, buildLinux, modDirVersionArg ? null, ... } @ args:

with stdenv.lib;

buildLinux (args // rec {
  version = "5.0.0-ck1";

  # modDirVersion needs to be x.y.z, will automatically add .0 if needed

  # branchVersion needs to be x.y
  extraMeta.branch = concatStrings (intersperse "." (take 2 (splitString "." version)));

  src = args.fetchFromGitHub {
    owner  = "ckolivas";
    repo   = "linux";
    rev    = "5.0-ck";
    sha256 = "121my4r1d79pwc7nfg1sq2sh0xphsl5bd54iklj2qhk4h19z46iy";
  };
} // (args.argsOverride or {}))

