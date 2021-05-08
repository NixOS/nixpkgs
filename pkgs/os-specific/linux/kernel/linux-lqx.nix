{ lib, fetchFromGitHub, buildLinux, linux_zen, ... } @ args:

let
  version = "5.11.18";
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
    sha256 = "0fz0s6bdcvbzy1149acqkq3aqg481dwiq85wh7ii1hx6p1gbsx71";
  };

  extraMeta = {
    branch = "5.10/master";
    maintainers = with lib.maintainers; [ atemu ];
    description = linux_zen.meta.description + " (Same as linux_zen but less aggressive release schedule)";
  };

} // (args.argsOverride or {}))
