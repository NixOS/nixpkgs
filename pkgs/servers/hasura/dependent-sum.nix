{ mkDerivation, base, stdenv }:
mkDerivation {
  pname = "dependent-sum";
  version = "0.4";
  sha256 = "a8deecb4153a1878173f8d0a18de0378ab068bc15e5035b9e4cb478e8e4e1a1e";
  libraryHaskellDepends = [ base ];
  homepage = "https://github.com/mokus0/dependent-sum";
  description = "Dependent sum type";
  license = stdenv.lib.licenses.publicDomain;
}
