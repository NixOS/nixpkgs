{cabal, tetex, polytable, regexCompat}:

#assert tetex == polytable.tetex;

cabal.mkDerivation (self : {
  pname = "lhs2tex";
  version = "1.16";
  name = self.fname;
  sha256 = "aa43ec92e8d7c94213365a7211d605314476977155e36420caa3cfb394f7c76f";
  extraBuildInputs = [tetex regexCompat];
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

