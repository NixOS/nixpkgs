{cabal, texLive, regexCompat}:

cabal.mkDerivation (self: {
  pname = "lhs2tex";
  version = "1.18.1";
  name = self.fname;
  sha256 = "0j4n7vkabsggn94gbwixy1vmckdck2nggdiqvk6n9nx164if5jnw";
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
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
