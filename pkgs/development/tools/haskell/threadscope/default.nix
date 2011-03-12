{cabal, binary, cairo, ghcEvents, glade, gtk, mtl}:

cabal.mkDerivation (self : {
  pname = "threadscope";
  version = "0.1.2";
  sha256 = "ce1116016f6b2d38e6063ba3dd147f38147a9c4399160f37aba9c50c96d00a90";
  propagatedBuildInputs = [binary cairo ghcEvents glade gtk mtl];
  preConfigure = ''
    sed -i 's|\(containers.*\) && < 0.4|\1|' ${self.pname}.cabal
  '';
  configureFlags = "--ghc-options=-rtsopts";
  meta = {
    description = "A graphical thread profiler";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})  

