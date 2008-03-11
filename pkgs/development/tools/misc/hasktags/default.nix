args:
args.stdenv.mkDerivation {
  name = "hasktags-modified";

  src = args.fetchurl {
    url = http://mawercer.de/hasktags.hs;
    sha256 = "8acb6f44fde650918ebdca9e9897a41fc62aae9cb3b86ab04dca56bf97592592";
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
