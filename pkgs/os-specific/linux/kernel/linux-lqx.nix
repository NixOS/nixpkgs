{ stdenv, fetchFromGitHub, buildLinux, linux_zen, ... } @ args:

let
  version = "5.10.6";
in

buildLinux (args // {
  modDirVersion = "${version}-lqx1";
  inherit version;
  isZen = true;

  src = fetchFromGitHub {
    owner = "zen-kernel";
    repo = "zen-kernel";
    rev = "v${version}-lqx1";
    sha256 = "0vvb00311yhf08ib3yvkjwk2j45f8r268ywg5299yjgbyl6g95kg";
  };

  extraMeta = {
    branch = "5.10/master";
    maintainers = with stdenv.lib.maintainers; [ atemu ];
    description = linux_zen.meta.description + " (Same as linux_zen but less aggressive release schedule)";
  };

} // (args.argsOverride or {}))
