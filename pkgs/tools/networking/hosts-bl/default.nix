{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "Hosts-BL";
  version = builtins.substring 0 7 src.rev;

  goPackagePath = "github.com/ScriptTiger/Hosts-BL";

  src = fetchFromGitHub {
    owner = "ScriptTiger";
    repo = pname;
    rev = "b8efebe4748ccd043eccc3df37725a16338451de";
    sha256 = "sha256-iBNsn9iM/6SuDWJTrEUDEYp1KdH/Ca2ibx1q4loN7Zo=";
  };

  meta = {
    description = "Simple tool to handle hosts file black lists";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.puffnfresh ];
    platforms = lib.platforms.unix;
  };
}
