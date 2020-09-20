{ stdenv, fetchFromGitHub, buildLinux, ... } @ args:

let
  version = "5.8.10";
in

buildLinux (args // {
  modDirVersion = "${version}-zen1";
  inherit version;

  src = fetchFromGitHub {
    owner = "zen-kernel";
    repo = "zen-kernel";
    rev = "v${version}-zen1";
    sha256 = "1mm4x2amnpwixvi7q8pj9my75b08ps2mafgz4j2iszpylkdzi53d";
  };

  extraMeta = {
    branch = "5.8/master";
    maintainers = with stdenv.lib.maintainers; [ atemu ];
  };

} // (args.argsOverride or {}))
