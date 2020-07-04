{ mkDerivation, base, containers, dependent-sum, stdenv }:
mkDerivation {
  pname = "dependent-map";
  version = "0.2.4.0";
  sha256 = "5db396bdb5d156434af920c074316c3b84b4d39ba8e1cd349c7bb6679cb28246";
  revision = "1";
  editedCabalFile = "0a5f35d1sgfq1cl1r5bgb5pwfjniiycxiif4ycxglaizp8g5rlr1";
  libraryHaskellDepends = [ base containers dependent-sum ];
  homepage = "https://github.com/mokus0/dependent-map";
  description = "Dependent finite maps (partial dependent products)";
  license = "unknown";
  hydraPlatforms = stdenv.lib.platforms.none;
}
