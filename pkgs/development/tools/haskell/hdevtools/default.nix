{ cabal, cmdargs, ghcPaths, network, syb, time, fetchpatch }:

cabal.mkDerivation (self: {
  pname = "hdevtools";
  version = "0.1.0.5";
  sha256 = "1a218m817q35f52fv6mn28sfv136i6fm2mzgdidpm24pc0585gl7";
  isLibrary = false;
  isExecutable = true;
  patches = [ (fetchpatch { url = "https://github.com/bitc/hdevtools/pull/28.patch"; sha256 = "1rlv5zskg4ns9ba791x72gycxrr52lhy8x164q38gpq600gh5n40"; }) ];
  buildDepends = [ cmdargs ghcPaths network syb time ];
  meta = {
    homepage = "https://github.com/bitc/hdevtools/";
    description = "Persistent GHC powered background server for FAST haskell development tools";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
