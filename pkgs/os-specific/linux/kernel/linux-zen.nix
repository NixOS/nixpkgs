{ stdenv, fetchFromGitHub, buildLinux, ... } @ args:

let
  version = "5.9.6";
in

buildLinux (args // {
  modDirVersion = "${version}-zen1";
  inherit version;
  isZen = true;

  src = fetchFromGitHub {
    owner = "zen-kernel";
    repo = "zen-kernel";
    rev = "v${version}-zen1";
    sha256 = "0v8nc2zy75ij4hn8js23998spadbiid8qc9cib5d0apmzkhilqwq";
  };

  extraMeta = {
    branch = "5.9/master";
    maintainers = with stdenv.lib.maintainers; [ atemu andresilva ];
  };

} // (args.argsOverride or {}))
