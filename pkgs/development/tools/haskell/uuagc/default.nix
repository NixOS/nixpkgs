{cabal, uulib}:

cabal.mkDerivation (self : {
  pname = "uuagc";
  version = "0.9.36";
  name = self.fname;
  sha256 = "02sl19apxwhgj7zq37pl6xkl35pafma2683d7hyzyyn6y5kqma1j";
  extraBuildInputs = [uulib];
  meta = {
    description = "Attribute Grammar System of Universiteit Utrecht";
  };
})
