{ lib, fetchFromGitHub, buildLinux, linux_zen, ... } @ args:

let
  version = "5.15.11";
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
    sha256 = "sha256-GCO2i4b/1DdYCoI2KCvBdMIGvmpCWLloSzYb31CtZ18=";
  };

  extraMeta = {
    branch = "5.14/master";
    maintainers = with lib.maintainers; [ atemu ];
    description = linux_zen.meta.description + " (Same as linux_zen but less aggressive release schedule)";
  };

} // (args.argsOverride or { }))
