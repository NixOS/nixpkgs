{ stdenv, fetchFromGitHub, buildLinux, linux_zen, ... } @ args:

let
  version = "5.10.5";
in

buildLinux (args // {
  modDirVersion = "${version}-lqx1";
  inherit version;
  isZen = true;

  src = fetchFromGitHub {
    owner = "zen-kernel";
    repo = "zen-kernel";
    rev = "v${version}-lqx1";
    sha256 = "1qnxmxahx1wpwhpjz6gdm5zdy1gd8ic3p7vqbz55vx4ygn865gyv";
  };

  extraMeta = {
    branch = "5.10/master";
    maintainers = with stdenv.lib.maintainers; [ atemu ];
    description = linux_zen.meta.description + " (Same as linux_zen but less aggressive release schedule)";
  };

} // (args.argsOverride or {}))
