{ lib, fetchFromGitHub, buildLinux, linux_zen, ... } @ args:

let
  version = "5.12.19";
  suffix = "lqx2";
in

buildLinux (args // {
  modDirVersion = "${version}-${suffix}";
  inherit version;
  isZen = true;

  src = fetchFromGitHub {
    owner = "zen-kernel";
    repo = "zen-kernel";
    rev = "v${version}-${suffix}";
    sha256 = "sha256-r2DvKLlm1a1VuJwC81tRuRwCd6H21T3MsBAC3b9TUbs=";
  };

  extraMeta = {
    branch = "5.12/master";
    maintainers = with lib.maintainers; [ atemu ];
    description = linux_zen.meta.description + " (Same as linux_zen but less aggressive release schedule)";
  };

} // (args.argsOverride or { }))
