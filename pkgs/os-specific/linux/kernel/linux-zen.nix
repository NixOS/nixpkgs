{ stdenv, fetchFromGitHub, buildLinux, ... } @ args:

let
  version = "5.9.12";
in

buildLinux (args // {
  modDirVersion = "${version}-zen1";
  inherit version;
  isZen = true;

  src = fetchFromGitHub {
    owner = "zen-kernel";
    repo = "zen-kernel";
    rev = "v${version}-zen1";
    sha256 = "07cmcw8ib9wc4im08pbmxhj187lhsfxh2asn4jdxadxxq3f60h6w";
  };

  extraMeta = {
    branch = "5.9/master";
    maintainers = with stdenv.lib.maintainers; [ atemu andresilva ];
  };

} // (args.argsOverride or {}))
