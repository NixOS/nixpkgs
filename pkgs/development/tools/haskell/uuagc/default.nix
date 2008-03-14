{cabal, uulib}:

cabal.mkDerivation (self : {
  pname = "uuagc";
  version = "0.9.5";
  name = self.fname;
  sha256 = "01babb063390448f127b897b10eb47a07fe0593b7fc8a5ab51826ad65a5e4526";
  extraBuildInputs = [uulib];
  meta = {
    description = "Attribute Grammar System of Universiteit Utrecht";
  };
})
