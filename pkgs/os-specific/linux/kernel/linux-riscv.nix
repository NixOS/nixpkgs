{ stdenv, buildPackages, hostPlatform, fetchFromGitHub, perl, buildLinux, libelf, utillinux, ... } @ args:

buildLinux (args // rec {
  version = "4.16-rc1";
  modDirVersion = "4.16.0-rc1";
  extraMeta.branch = "4.16";

  src = fetchFromGitHub {
    owner = "riscv";
    repo ="riscv-linux";
    rev = "a31991a9c6ce2c86fd676cf458a0ec10edc20d37";
    sha256 = "0n97wfbi3pnp5c70xfj7s0fk8zjjkjz6ldxh7n54kbf64l4in01f";
  };

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
