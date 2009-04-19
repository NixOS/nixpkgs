{cabal, uulib}:

cabal.mkDerivation (self : {
  pname = "uuagc";
  version = "0.9.10";
  name = self.fname;
  sha256 = "cdbe78b6138a67bbc612f0f667f70ba483ebbdaa4d0c87c5508cfb5e68a49dcb";
  extraBuildInputs = [uulib];
  meta = {
    description = "Attribute Grammar System of Universiteit Utrecht";
  };
})
