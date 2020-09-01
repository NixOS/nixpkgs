{ stdenv, fetchFromGitHub, buildLinux, ... } @ args:

let
  version = "5.8.5";
in

buildLinux (args // {
  modDirVersion = "${version}-zen1";
  inherit version;

  src = fetchFromGitHub {
    owner = "zen-kernel";
    repo = "zen-kernel";
    rev = "v${version}-zen1";
    sha256 = "1yf4hlv6dfisdasziv41i57cn9n1w6h16ckp85kl9r25ky8cdccr";
  };

  extraMeta = {
    branch = "5.8/master";
    maintainers = with stdenv.lib.maintainers; [ atemu rvolosatovs ];
  };

} // (args.argsOverride or {}))
