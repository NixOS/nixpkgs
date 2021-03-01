{ lib, fetchFromGitHub, buildLinux, linux_zen, ... } @ args:

let
  version = "5.10.10";
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
    sha256 = "1cjgx9qjfkiaalqkcdmibsrq2frwd621rwcg6w05ms4w9lnwi3af";
  };

  extraMeta = {
    branch = "5.10/master";
    maintainers = with lib.maintainers; [ atemu ];
    description = linux_zen.meta.description + " (Same as linux_zen but less aggressive release schedule)";
  };

} // (args.argsOverride or {}))
