{ stdenv, lib, buildLinux, fetchFromGitHub, ... } @ args:

buildLinux (args // rec {
  version = "5.12-ck1";
  modDirVersion = "5.12.0-ck1";

  src = fetchFromGitHub {
    owner = "ckolivas";
    repo = "linux";
    rev = version;
    sha256 = "sha256-KcURl4Lcaki2SdOIUGoHZYziCqf4iK9Fk67K3WKH3g8=";
  };

  ignoreConfigErrors = true;

  extraMeta = {
    branch = "5.12-ck1";
    maintainers = with lib.maintainers; [ dan4ik605743 ];
    description = "The Linux-ck kernel and modules with the ck1 patchset featuring MuQSS CPU scheduler";
    broken = stdenv.isAarch64;
  };
} // (args.argsOverride or { }))
