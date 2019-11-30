{ lib, crystal, fetchFromGitHub, sqlite, pkgconfig }:

crystal.buildCrystalPackage rec {
  name = "amber";
  version = "0.31.0";
  owner = "amberframework";
  repo = "amber";

  src = fetchFromGitHub {
    inherit owner repo;
    rev = "v${version}";
    sha256 = "0pygy42gx64qmg4m6lj1cfwmm8g7fka08rx3qvp03z6zjj2qs77k";
  };

  buildInputs = [ sqlite pkgconfig ];

	shardsFile = ./shards.nix;

  crystalBinaries.amber.src = "src/amber/cli.cr";

  passthru.updateScript = crystal.updateCrystalPackage { inherit owner repo; };

  meta = {
    description = "Crystal web framework that makes building applications fast, simple, and enjoyable";
    homepage = https://amberframework.org/;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ manveru ];
    platforms = [ "x86_64-linux" "i686-linux" "x86_64-darwin" ];
  };
}
