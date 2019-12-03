{ lib, fetchFromGitHub, crystal }:

crystal.buildCrystalPackage rec {
  pname = "scry";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "crystal-lang-tools";
    repo = pname;
    rev = "v${version}";
    sha256 = "0ii4k9l3dgm1c9lllc8ni9dar59lrxik0v9iz7gk3d6v62wwnq79";
  };

  shardsFile = ./shards.nix;
  crystalBinaries.scry.src = "src/scry.cr";

  meta = with lib; {
    description = "Code analysis server for the Crystal programming language";
    homepage = "https://github.com/crystal-lang-tools/scry";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg filalex77 ];
  };
}
