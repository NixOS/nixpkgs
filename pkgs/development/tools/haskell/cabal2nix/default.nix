{ cabal, Cabal, filepath, hackageDb, HTTP, mtl, regexPosix }:

cabal.mkDerivation (self: {
  pname = "cabal2nix";
  version = "1.38";
  sha256 = "1kybxrkddbzr1cqpqplbflhakf9njb9hvamhdwvlanlk8985h8jg";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ Cabal filepath hackageDb HTTP mtl regexPosix ];
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
