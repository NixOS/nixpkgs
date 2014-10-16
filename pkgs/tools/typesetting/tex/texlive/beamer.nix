args: with args;
rec {
  name = "texlive-beamer-2013";
  src = fetchurl {
    url = mirror://debian/pool/main/l/latex-beamer/latex-beamer_3.24.orig.tar.gz;
    sha256 = "0rzjlbs67kzmvlh7lwga4yxgddvrvfkkhhx1ajdn4lqy2w9zxiv8";
  };

  buildInputs = [texLive];
  propagatedBuildInputs = [texLiveLatexXColor texLivePGF];
  phaseNames = ["doCopy"];
  doCopy = fullDepEntry (''
    mkdir -p $out/share/

    mkdir -p $out/texmf-dist/tex/latex/beamer
    cp -r * $out/texmf-dist/tex/latex/beamer 

    ln -s $out/texmf* $out/share/
  '') ["minInit" "doUnpack" "defEnsureDir" "addInputs"];

  meta = {
    description = "Extra components for TeXLive: beamer class";
    maintainers = [ stdenv.lib.maintainers.mornfall stdenv.lib.maintainers.jwiegley ];
  };
}
