{ stdenv, fetchFromGitHub, buildLinux, ... } @ args:

let
  version = "5.8.13";
in

buildLinux (args // {
  modDirVersion = "${version}-zen1";
  inherit version;
  isZen = true;

  src = fetchFromGitHub {
    owner = "zen-kernel";
    repo = "zen-kernel";
    rev = "v${version}-zen1";
    sha256 = "161bvrmic7gspkgkv0pqssk6dzv95vkxld69rir968khwlnpsnim";
  };

  extraMeta = {
    branch = "5.8/master";
    maintainers = with stdenv.lib.maintainers; [ atemu ];
  };

} // (args.argsOverride or {}))
