args:
args.stdenv.mkDerivation {
  name = "hasktags-modified";

  src = args.fetchurl {
    url = http://mawercer.de/hasktags.hs;
    sha256 = "9694256922899221a547f0ece57b192ba86761b42acb208424a011d55c51b603";
  };

  buildInputs =(with args; [ghc]);

  phases = "buildPhase";

  # calling it hasktags-modified to not clash with the one distributed with ghc
  buildPhase = "
    ensureDir \$out/bin
    ghc --make \$src -o \$out/bin/hasktags-modified
  ";

  meta = { 
      # this can be removed again when somone comitts my changes into the distribution
      description = "Marc's modified hasktags";
  };
}
