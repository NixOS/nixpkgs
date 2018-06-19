{ stdenv, buildPackages, hostPlatform, fetchFromGitHub, perl, buildLinux, libelf, utillinux, ... } @ args:

buildLinux (args // rec {
  version = "4.14.47-139";

  # modDirVersion needs to be x.y.z.
  modDirVersion = "4.14.47";

  # branchVersion needs to be x.y. 
  extraMeta.branch = "4.14";

  src = fetchFromGitHub {
    owner = "hardkernel";
    repo = "linux";
    rev = version;
    sha256 = "0jjgrmvi1h8zs8snnvghnjd422yfmn7jv9y1n7xikmfv4nvwqrkv";
  };

} // (args.argsOverride or {}))
