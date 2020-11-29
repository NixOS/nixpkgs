{ stdenv, fetchFromGitHub, buildLinux, ... } @ args:

let
  version = "5.9.11";
in

buildLinux (args // {
  modDirVersion = "${version}-zen2";
  inherit version;
  isZen = true;

  src = fetchFromGitHub {
    owner = "zen-kernel";
    repo = "zen-kernel";
    rev = "v${version}-zen2";
    sha256 = "1qipxicd8a094y28nv6cb4kzcc29hz7yg39fz4faly2rwivirv81";
  };

  extraMeta = {
    branch = "5.9/master";
    maintainers = with stdenv.lib.maintainers; [ atemu andresilva ];
  };

} // (args.argsOverride or {}))
