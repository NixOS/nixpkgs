{ stdenv, fetchFromGitHub, buildLinux, ... } @ args:

let
  version = "5.9.13";
in

buildLinux (args // {
  modDirVersion = "${version}-zen1";
  inherit version;
  isZen = true;

  src = fetchFromGitHub {
    owner = "zen-kernel";
    repo = "zen-kernel";
    rev = "v${version}-zen1";
    sha256 = "13sv794srmf1p13pb07pl6c4fxw2f1vjkxj8dkdgfhy03b0iasa2";
  };

  extraMeta = {
    branch = "5.9/master";
    maintainers = with stdenv.lib.maintainers; [ atemu andresilva ];
  };

} // (args.argsOverride or {}))
