{ cabal, Cabal, doctest, filepath, hackageDb, HTTP, mtl, regexPosix
}:

cabal.mkDerivation (self: {
  pname = "cabal2nix";
  version = "1.63";
  sha256 = "12frnhm86w5i6rmhghrdngdv658332bh9j5nr04ql439yysvkypj";
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
