{cabal, perl}:

cabal.mkDerivation (self : {
  pname = "alex";
  version = "2.2";
  name = self.fname;
  sha256 = "e958d4fc6cfdb1d351dc39a45ea882f23b1b1773a736d43814a52d4939a41ffe";
  extraBuildInputs = [perl];
  meta = {
    description = "A lexical analyser generator for Haskell";
  };
})
