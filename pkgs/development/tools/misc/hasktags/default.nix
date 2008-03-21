args:
args.stdenv.mkDerivation {
  name = "hasktags-modified";

  src = args.fetchurl {
    url = http://mawercer.de/hasktags.hs;
    sha256 = "2c26d79fbea9dddf140022b21e8dc82562163c8457ec1fb66b351029274f856c";
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
