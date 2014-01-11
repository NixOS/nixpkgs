args: with args;
rec {
  name = "texlive-extra-2013";
  src = fetchurl {
    url = mirror://debian/pool/main/t/texlive-extra/texlive-extra_2013.20131219.orig.tar.xz;
    sha256 = "09iijzq0y5kq16f3lv2jrln190ldbbzywpwr33hrmnw5yp3izmrh";
  };

  buildInputs = [texLive xz];
  phaseNames = ["doCopy"];
  doCopy = fullDepEntry (''
    mkdir -p $out/share
    cp -r texmf* $out/
    ln -s $out/texmf* $out/share
  '') ["minInit" "doUnpack" "defEnsureDir" "addInputs"];

  meta = {
    description = "Extra components for TeXLive";
    maintainers = [ args.lib.maintainers.raskin ];

    # Actually, arch-independent.. 
    hydraPlatforms = [];
  };
}
