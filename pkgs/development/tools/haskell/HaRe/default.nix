{cabal, hint, mtl, network}:

cabal.mkDerivation (self : {
  pname = "HaRe";
  version = "0.6.0.1";
  sha256 = "cd3fa312c7fa6a5f761bbc3ebdbc6300e83ba9e285047acded6269d2164d67f8";
  propagatedBuildInputs = [hint mtl network];
  meta = {
    description = "The Haskell Refactorer";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})  

