{ lib, fetchFromGitHub, buildLinux, ... } @ args:

let
  version = "5.10.15";
  suffix = "zen2";
in

buildLinux (args // {
  modDirVersion = "${version}-${suffix}";
  inherit version;
  isZen = true;

  src = fetchFromGitHub {
    owner = "zen-kernel";
    repo = "zen-kernel";
    rev = "v${version}-${suffix}";
    sha256 = "18qgh79hi1ph6x16sbvq36icv7c5bkdvh193wqjnbvwf0yph09as";
  };

  extraMeta = {
    branch = "5.10/master";
    maintainers = with lib.maintainers; [ atemu andresilva ];
    description = "Built using the best configuration and kernel sources for desktop, multimedia, and gaming workloads.";
  };

} // (args.argsOverride or {}))
