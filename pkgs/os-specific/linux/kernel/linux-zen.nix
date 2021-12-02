{ lib, fetchFromGitHub, buildLinux, ... } @ args:

let
  # having the full version string here makes it easier to update
  modDirVersion = "5.15.6-zen2";
  parts = lib.splitString "-" modDirVersion;
  version = lib.elemAt parts 0;
  suffix = lib.elemAt parts 1;

  numbers = lib.splitString "." version;
  branch = "${lib.elemAt numbers 0}.${lib.elemAt numbers 1}";
in

buildLinux (args // {
  inherit version modDirVersion;
  isZen = true;

  src = fetchFromGitHub {
    owner = "zen-kernel";
    repo = "zen-kernel";
    rev = "v${modDirVersion}";
    sha256 = "sha256-lakNE+Ac3AHfD6e9haXkwQL134UNduk8o8UNtyAQ4U0=";
  };

  structuredExtraConfig = with lib.kernel; {
    ZEN_INTERACTIVE = yes;
  };

  extraMeta = {
    inherit branch;
    maintainers = with lib.maintainers; [ atemu andresilva ];
    description = "Built using the best configuration and kernel sources for desktop, multimedia, and gaming workloads.";
  };

} // (args.argsOverride or { }))
