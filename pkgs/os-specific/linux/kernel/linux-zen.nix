{ stdenv, fetchFromGitHub, buildLinux, ... } @ args:

let
  version = "5.8.1";
in

buildLinux (args // {
  modDirVersion = "${version}-zen1";
  inherit version;

  src = fetchFromGitHub {
    owner = "zen-kernel";
    repo = "zen-kernel";
    rev = "v${version}-zen1";
    sha256 = "122q09d0sybi9lqlaxpq6ffc0ha9127bg3wzjync256lbj5394b7";
  };

  extraMeta = {
    branch = "5.8/master";
    maintainers = with stdenv.lib.maintainers; [ atemu ];
  };

} // (args.argsOverride or {}))
