{ cabal, cmdargs, ghcPaths, network, syb, time, fetchurl }:

cabal.mkDerivation (self: {
  pname = "hdevtools";
  version = "0.1.0.6-pre-github-schell-9e34f7dd";
  sha256 = "1a218m817q35f52fv6mn28sfv136i6fm2mzgdidpm24pc0585gl7";
  isLibrary = false;
  isExecutable = true;
  wrapExecutable = true;
  #patches = [ (fetchurl { url = "https://github.com/ts468/hdevtools/pull/2.diff"; md5 = "a974995a85bf03fe1b156d8ab76108bf"; }) ];
  patches = [ ./github-schell.diff ];
  buildDepends = [ cmdargs ghcPaths network syb time ];
  meta = {
    homepage = "https://github.com/bitc/hdevtools/";
    description = "Persistent GHC powered background server for FAST haskell development tools";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
