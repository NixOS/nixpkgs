{ lib, stdenv, buildLinux, fetchFromGitHub, ... } @ args:

let
  version = "5.12.11";
  suffix = "xanmod1-cacule";
in
buildLinux (args // rec {
  modDirVersion = "${version}-${suffix}";
  inherit version;

  src = fetchFromGitHub {
    owner = "xanmod";
    repo = "linux";
    rev = modDirVersion;
    sha256 = "sha256-EQ52Leg7i1Xb2b29JbaKFKRE/jKXB48GXhbM/Ay5QTY=";
  };

  extraMeta = {
    branch = "5.12-cacule";
    maintainers = with lib.maintainers; [ fortuneteller2k ];
    description = "Built with custom settings and new features built to provide a stable, responsive and smooth desktop experience";
    broken = stdenv.isAarch64;
  };
} // (args.argsOverride or { }))
