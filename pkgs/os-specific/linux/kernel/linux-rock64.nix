{ stdenv, buildPackages, fetchFromGitHub, perl, buildLinux, modDirVersionArg ? null, ... } @ args:

with stdenv.lib;

buildLinux (args // rec {
  version = "4.4.202";

  # modDirVersion needs to be x.y.z, will automatically add .0 if needed
  modDirVersion = if (modDirVersionArg == null) then concatStringsSep "." (take 3 (splitVersion "${version}.0")) else modDirVersionArg;

  # branchVersion needs to be x.y
  extraMeta.branch = versions.majorMinor version;

  src = fetchFromGitHub {
    owner = "ayufan-rock64";
    repo = "linux-kernel";
    rev = "4.4.202-1237-rockchip-ayufan";
    sha256 = "1qcw7h8kkj6kv8vzfrnhih0854h1iss65grjc8p8npff1397l48m";
  };

  defconfig = "rockchip_linux_defconfig";

  autoModules = false;

} // (args.argsOverride or {}))
