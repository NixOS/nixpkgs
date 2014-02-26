{ cabal, Cabal, doctest, filepath, hackageDb, HTTP, mtl, regexPosix
}:

cabal.mkDerivation (self: {
  pname = "cabal2nix";
  version = "1.60";
  sha256 = "1jp4rq8gfdz5knm9cbralhjyw2a391cck49422bskl7c23p94y3l";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ Cabal filepath hackageDb HTTP mtl regexPosix ];
  testDepends = [ doctest ];
  doCheck = self.stdenv.lib.versionOlder "7.6" self.ghc.version;
  meta = {
    homepage = "http://github.com/NixOS/cabal2nix";
    description = "Convert Cabal files into Nix build instructions";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
