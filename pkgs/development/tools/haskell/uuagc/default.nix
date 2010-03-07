{cabal, uulib}:

cabal.mkDerivation (self : {
  pname = "uuagc";
  version = "0.9.14";
  name = self.fname;
  sha256 = "076250219874b03fc04473a71f6fc6e1c2324f3a65e98a6f7afcaa42de4dea0c";
  extraBuildInputs = [uulib];
  meta = {
    description = "Attribute Grammar System of Universiteit Utrecht";
  };
})
