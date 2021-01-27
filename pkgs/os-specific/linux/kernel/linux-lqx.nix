{ lib, fetchFromGitHub, buildLinux, linux_zen, ... } @ args:

let
  version = "5.10.11";
  suffix = "lqx1";
in

buildLinux (args // {
  modDirVersion = "${version}-${suffix}";
  inherit version;
  isZen = true;

  src = fetchFromGitHub {
    owner = "zen-kernel";
    repo = "zen-kernel";
    rev = "v${version}-${suffix}";
    sha256 = "07lbbwzx26y3md7sci8jhzl8n5sygz61hwhymgb7r1iy2zggzsxn";
  };

  extraMeta = {
    branch = "5.10/master";
    maintainers = with lib.maintainers; [ atemu ];
    description = linux_zen.meta.description + " (Same as linux_zen but less aggressive release schedule)";
  };

} // (args.argsOverride or {}))
