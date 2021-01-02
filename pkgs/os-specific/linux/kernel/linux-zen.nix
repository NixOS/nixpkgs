{ stdenv, fetchFromGitHub, buildLinux, ... } @ args:

let
  version = "5.10.4";
in

buildLinux (args // {
  modDirVersion = "${version}-zen2";
  inherit version;
  isZen = true;

  src = fetchFromGitHub {
    owner = "zen-kernel";
    repo = "zen-kernel";
    rev = "v${version}-zen2";
    sha256 = "1sgkpqpa16k6k19858y0p9hb0jwwwz0929g3p3jcfldlhrscafpl";
  };

  extraMeta = {
    branch = "5.10/master";
    maintainers = with stdenv.lib.maintainers; [ atemu andresilva ];
    description = "Built using the best configuration and kernel sources for desktop, multimedia, and gaming workloads.";
  };

} // (args.argsOverride or {}))
