{ stdenv, fetchFromGitHub, buildLinux, linux_zen, ... } @ args:

let
  version = "5.9.16";
in

buildLinux (args // {
  modDirVersion = "${version}-lqx1";
  inherit version;
  isZen = true;

  src = fetchFromGitHub {
    owner = "zen-kernel";
    repo = "zen-kernel";
    rev = "v${version}-lqx1";
    sha256 = "0ljvqf91nxpql98z75bicg5y3nzkm41rq5b0rm1kcnsk0ji829ps";
  };

  extraMeta = {
    branch = "5.9/master";
    maintainers = with stdenv.lib.maintainers; [ atemu ];
    description = linux_zen.meta.description + " (Same as linux_zen but less aggressive release schedule)";
  };

} // (args.argsOverride or {}))
