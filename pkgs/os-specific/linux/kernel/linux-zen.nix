{ stdenv, fetchFromGitHub, buildLinux, ... } @ args:

let
  version = "5.10.1";
in

buildLinux (args // {
  modDirVersion = "${version}-zen1";
  inherit version;
  isZen = true;

  src = fetchFromGitHub {
    owner = "zen-kernel";
    repo = "zen-kernel";
    rev = "v${version}-zen1";
    sha256 = "1c77x53ixyn64b4qq6br6ckicmjs316c8k08yfxibmhv72av1wcp";
  };

  extraMeta = {
    branch = "5.10/master";
    maintainers = with stdenv.lib.maintainers; [ atemu andresilva ];
    description = "Built using the best configuration and kernel sources for desktop, multimedia, and gaming workloads.";
  };

} // (args.argsOverride or {}))
