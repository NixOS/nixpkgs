{ stdenv, buildPackages, hostPlatform, fetchFromGitHub, perl, buildLinux, libelf, utillinux, ... } @ args:

buildLinux (args // rec {
  version = "4.16-rc6";
  modDirVersion = "4.16.0-rc6";
  extraMeta.branch = "4.16";

  src = fetchFromGitHub {
    owner = "shlevy";
    repo ="riscv-linux";
    rev = "a54f259c2adce68e3bd7600be8989bf1ddf9ea3a";
    sha256 = "140w6mj4hm1vf4zsmcr2w5cghcaalbvw5d4m9z57dmq1z5plsl4q";
  };

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
