{ cabal, cmdargs, ghcPaths, network, syb, time, fetchurl }:

cabal.mkDerivation (self: {
  pname = "hdevtools";
  version = "0.1.0.6-pre-github-schell-9e34f7dd";
  sha256 = "1a218m817q35f52fv6mn28sfv136i6fm2mzgdidpm24pc0585gl7";
  isLibrary = false;
  isExecutable = true;
  patches = [ (fetchurl { url = "https://github.com/ts468/hdevtools/pull/2.patch"; sha256 = "104vdw6qxl71fdg43ppv0hrg6k17zaijq73vap794178d3gb35al"; }) ];
  buildDepends = [ cmdargs ghcPaths network syb time ];
  meta = {
    homepage = "https://github.com/bitc/hdevtools/";
    description = "Persistent GHC powered background server for FAST haskell development tools";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
