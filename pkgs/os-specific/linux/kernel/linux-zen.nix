{ stdenv, fetchFromGitHub, buildLinux, ... } @ args:

let
  version = "5.7.10";
in

buildLinux (args // {
  modDirVersion = "${version}-zen1";
  inherit version;

  src = fetchFromGitHub {
    owner = "zen-kernel";
    repo = "zen-kernel";
    rev = "v${version}-zen1";
    sha256 = "0m9abjs7xv80zgk5qx7iimxaycif8dlr0g0kzkjyaw9mxji6gp37";
  };

  extraMeta = {
    branch = "5.7/master";
    maintainers = with stdenv.lib.maintainers; [ atemu ];
  };

} // (args.argsOverride or {}))
