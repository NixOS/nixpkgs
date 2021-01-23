{ lib, stdenv, fetchFromGitHub, buildLinux, linux_zen, ... } @ args:

let
  version = "5.10.9";
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
    sha256 = "1j0rz4j1br7kzg9zb5l2xz60ccr4iwjndxq3f4gml8s3fb4cpp6f";
  };

  extraMeta = {
    branch = "5.10/master";
    maintainers = with lib.maintainers; [ atemu ];
    description = linux_zen.meta.description + " (Same as linux_zen but less aggressive release schedule)";
  };

} // (args.argsOverride or {}))
