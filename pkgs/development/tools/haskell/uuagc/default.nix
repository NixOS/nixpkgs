{cabal, uulib}:

cabal.mkDerivation (self : {
  pname = "uuagc";
  version = "0.9.29";
  name = self.fname;
  sha256 = "325d395abcc1f8224400a3cd765dd187e6be64a782251aa33080aab008b8829e";
  extraBuildInputs = [uulib];
  meta = {
    description = "Attribute Grammar System of Universiteit Utrecht";
  };
})
