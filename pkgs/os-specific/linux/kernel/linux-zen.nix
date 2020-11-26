{ stdenv, fetchFromGitHub, buildLinux, ... } @ args:

let
  version = "5.9.10";
in

buildLinux (args // {
  modDirVersion = "${version}-zen1";
  inherit version;
  isZen = true;

  src = fetchFromGitHub {
    owner = "zen-kernel";
    repo = "zen-kernel";
    rev = "v${version}-zen1";
    sha256 = "0836mclwr3r4hm4pn8hp21sk14avrfwiv2s8lqx3cjasgdbyi826";
  };

  extraMeta = {
    branch = "5.9/master";
    maintainers = with stdenv.lib.maintainers; [ atemu andresilva ];
  };

} // (args.argsOverride or {}))
