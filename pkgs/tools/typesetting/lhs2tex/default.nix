{cabal, tetex, polytable, regexCompat, utf8String}:

#assert tetex == polytable.tetex;

cabal.mkDerivation (self : {
  pname = "lhs2tex";
  version = "1.15";
  name = self.fname;
  sha256 = "77f25c1f22823587ceca6eead133a403540319a0ae3bf03a369b3e8c86baf124";
  extraBuildInputs = [tetex regexCompat utf8String];
  propagatedBuildInputs = [polytable]; # automatically in user-env now with cabal

  postInstall = ''
    ensureDir "$out/share/doc/$name"
    cp doc/Guide2.pdf $out/share/doc/$name
    ensureDir "$out/nix-support"
  '';

  meta = {
    description = "Preprocessor for typesetting Haskell sources with LaTeX";
    license = "GPLv2";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})

