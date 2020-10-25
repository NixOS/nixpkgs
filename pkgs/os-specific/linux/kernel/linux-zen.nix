{ stdenv, fetchFromGitHub, buildLinux, ... } @ args:

let
  version = "5.9.3";
in

buildLinux (args // {
  modDirVersion = "${version}-zen1";
  inherit version;
  isZen = true;

  src = fetchFromGitHub {
    owner = "zen-kernel";
    repo = "zen-kernel";
    rev = "v${version}-zen1";
    sha256 = "0004fp3qnz2dpahnxkbc02yyijyqiavqmacyng1fi5wrw5kl2aj3";
  };

  extraMeta = {
    branch = "5.9/master";
    maintainers = with stdenv.lib.maintainers; [ atemu andresilva ];
  };

} // (args.argsOverride or {}))
