args:
args.stdenv.mkDerivation {
  name = "hasktags-modified";

  src = args.fetchurl {
    url = http://mawercer.de/hasktags.hs;
    sha256 = "af43a7fb1280aeec06ad3cfe6a7a01cf69b96f6dcd736e228b7532b79e6e51c5";
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
