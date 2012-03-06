{cabal, texLive, regexCompat}:

cabal.mkDerivation (self: {
  pname = "lhs2tex";
  version = "1.17";
  name = self.fname;
  sha256 = "1x49316m5xm4f6hw5q7kia9rpfpygxhk5gnifd54ai0zjmdlkxrc";
  extraBuildInputs = [regexCompat texLive];

  postInstall = ''
    mkdir -p "$out/share/doc/$name"
    cp doc/Guide2.pdf $out/share/doc/$name
    mkdir -p "$out/nix-support"
  '';

  meta = {
    homepage = "http://www.andres-loeh.de/lhs2tex/";
    description = "Preprocessor for typesetting Haskell sources with LaTeX";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})

