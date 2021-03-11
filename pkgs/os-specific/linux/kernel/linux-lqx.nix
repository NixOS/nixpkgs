{ lib, fetchFromGitHub, buildLinux, linux_zen, ... } @ args:

let
  version = "5.11.5";
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
    sha256 = "1rf8x08l7zjwhfwaal8kh2wz2qfbrqrjhr4wh0pj7yayaa10877f";
  };

  extraMeta = {
    branch = "5.10/master";
    maintainers = with lib.maintainers; [ atemu ];
    description = linux_zen.meta.description + " (Same as linux_zen but less aggressive release schedule)";
  };

} // (args.argsOverride or {}))
