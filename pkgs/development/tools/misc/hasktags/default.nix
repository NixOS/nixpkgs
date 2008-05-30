args:
args.stdenv.mkDerivation {
  name = "hasktags-modified";

  src = args.fetchurl {
    url = http://mawercer.de/hasktags.hs;
    sha256 = "1dpf91s8k5gnykdhp6y94gimbh7z58156f5d8y918wxmj08gbb8g";
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
