{ stdenv, fetchFromGitHub, buildLinux, ... } @ args:

let
  version = "5.9.14";
in

buildLinux (args // {
  modDirVersion = "${version}-zen1";
  inherit version;
  isZen = true;

  src = fetchFromGitHub {
    owner = "zen-kernel";
    repo = "zen-kernel";
    rev = "v${version}-zen1";
    sha256 = "1b8pm80z49d7qk9mvdf9w3hih34pilqr1zjk110q5im1kdz81zrg";
  };

  extraMeta = {
    branch = "5.9/master";
    maintainers = with stdenv.lib.maintainers; [ atemu andresilva ];
  };

} // (args.argsOverride or {}))
