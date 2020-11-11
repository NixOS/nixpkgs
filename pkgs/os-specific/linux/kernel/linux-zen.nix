{ stdenv, fetchFromGitHub, buildLinux, ... } @ args:

let
  version = "5.9.8";
in

buildLinux (args // {
  modDirVersion = "${version}-zen1";
  inherit version;
  isZen = true;

  src = fetchFromGitHub {
    owner = "zen-kernel";
    repo = "zen-kernel";
    rev = "v${version}-zen1";
    sha256 = "11dmz669m8jwcbgk04x0kandrh65fsn3d3zp7pikpw7ib635j9ra";
  };

  extraMeta = {
    branch = "5.9/master";
    maintainers = with stdenv.lib.maintainers; [ atemu andresilva ];
  };

} // (args.argsOverride or {}))
