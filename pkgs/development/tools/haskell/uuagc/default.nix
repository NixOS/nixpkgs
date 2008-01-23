{cabal, uulib}:

cabal.mkDerivation (self : {
  pname = "uuagc";
  version = "0.9.5";
  name = self.fname;
  sha256 = "c5be435efa609f72c09e175dd5cf7835a060bd7eaf6634ec4cde72ea84b99f25";
  extraBuildInputs = [uulib];
  meta = {
    description = "Attribute Grammar System of Universiteit Utrecht";
  };
})
