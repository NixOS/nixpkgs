{ stdenv, buildPackages, hostPlatform, fetchFromGitHub, perl, buildLinux, libelf, utillinux, ... } @ args:

buildLinux (args // rec {
  version = "4.16-rc2";
  modDirVersion = "4.16.0-rc2";
  extraMeta.branch = "4.16";

  src = fetchFromGitHub {
    owner = "shlevy";
    repo ="riscv-linux";
    rev = "f0c42cff9292c0a8e6ca702a54aafa04b35758a6";
    sha256 = "050mdciyz1595z81zsss0v9vqsaysppyzqaqpfs5figackifv3iv";
  };

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
