{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, libre ? false, ... } @ args:

with stdenv.lib;

buildLinux (args // rec {
  version = "4.15.9" + (if libre then "-gnu" else "");

  # modDirVersion needs to be x.y.z, will automatically add .0 if needed
  modDirVersion = concatStrings (intersperse "." (take 3 (splitString "." "${version}.0")));

  # branchVersion needs to be x.y
  extraMeta.branch = concatStrings (intersperse "." (take 2 (splitString "." version)));

  src = fetchurl {
    url = if !libre
          then "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz"
          else "https://www.linux-libre.fsfla.org/pub/linux-libre/releases/${version}/linux-libre-${version}.tar.xz";
    sha256 = if !libre
             then "14j4dpg1qx3bqw040lc6qkm544nz8qw5bpjnvz8ccw9f0jr1b86x"
             else "13lcard7i6w2c1cf9rfhvmq79xk4qp2p1c1920mfi69l20yvm572";
  };
} // (args.argsOverride or {}))
