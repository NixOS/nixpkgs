{ lib, fetchFromGitHub, buildLinux, ... } @ args:

let
  version = "5.13.9";
  suffix = "zen1";
in

buildLinux (args // {
  modDirVersion = "${version}-${suffix}";
  inherit version;
  isZen = true;

  src = fetchFromGitHub {
    owner = "zen-kernel";
    repo = "zen-kernel";
    rev = "v${version}-${suffix}";
    sha256 = "sha256-RuY6ZIIKU56R+IGMtQDV6mIubGDqonRpsIdlrpAHFXM=";
  };

  structuredExtraConfig = with lib.kernel; {
    ZEN_INTERACTIVE = yes;
  };

  extraMeta = {
    branch = "5.13";
    maintainers = with lib.maintainers; [ atemu andresilva ];
    description = "Built using the best configuration and kernel sources for desktop, multimedia, and gaming workloads.";
  };

} // (args.argsOverride or { }))
