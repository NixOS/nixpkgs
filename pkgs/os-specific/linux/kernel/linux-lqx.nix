{ stdenv, fetchFromGitHub, buildLinux, ... } @ args:

let
  version = "5.9.15";
in

buildLinux (args // {
  modDirVersion = "${version}-lqx1";
  inherit version;
  isZen = true;

  src = fetchFromGitHub {
    owner = "zen-kernel";
    repo = "zen-kernel";
    rev = "v${version}-lqx1";
    sha256 = "1srkybhgm3rsmhs4m8ipv1zi4y1dxnlicgh0x9v2g4myn58lin57";
  };

  extraMeta = {
    branch = "5.9/master";
    maintainers = with stdenv.lib.maintainers; [ atemu ];
  };

} // (args.argsOverride or {}))
