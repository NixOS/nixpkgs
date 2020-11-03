{ stdenv, fetchFromGitHub, buildLinux, ... } @ args:

let
  version = "5.8.7";
in

buildLinux (args // {
  modDirVersion = "${version}-zen1";
  inherit version;
  isZen = true;

  src = fetchFromGitHub {
    owner = "zen-kernel";
    repo = "zen-kernel";
    rev = "v${version}-zen1";
    sha256 = "06s7dpfxvwqfyh8qm8krcaxy98ki26cgh67k12g734bclg4bqsc5";
  };

  extraMeta = {
    branch = "5.8/master";
    maintainers = with stdenv.lib.maintainers; [ atemu ];
  };

} // (args.argsOverride or {}))
