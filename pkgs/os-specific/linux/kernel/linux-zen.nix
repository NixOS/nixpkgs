{ lib, fetchFromGitHub, buildLinux, ... } @ args:

let
  version = "5.13.5";
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
    sha256 = "sha256-3guG482lsdcWqAJ1kY757D4EeOEpTDvy95de0bHif98=";
  };

  extraMeta = {
    branch = "5.12/master";
    maintainers = with lib.maintainers; [ atemu andresilva ];
    description = "Built using the best configuration and kernel sources for desktop, multimedia, and gaming workloads.";
  };

} // (args.argsOverride or { }))
