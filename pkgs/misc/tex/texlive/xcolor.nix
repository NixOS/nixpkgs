args: with args;
rec {
  name = "texlive-latex-xcolor-2007";
  src = fetchurl {
    url = mirror://debian/pool/main/l/latex-xcolor/latex-xcolor_2.11.orig.tar.gz;
    sha256 = "0z78xfn5iq5ncg82sd6v2qrxs8p9hs3m4agaz90p4db5dvk2w0mn";
  };

  buildInputs = [texLive];
  phaseNames = ["doCopy"];
  doCopy = fullDepEntry (''
    export HOME=$PWD

    ensureDir $out/share/texmf/tex/latex/xcolor
    ensureDir $out/share/texmf/dvips/xcolor
    latex xcolor.ins 
    cp *.sty *.def $out/share/texmf/tex/latex/xcolor
    cp *.pro $out/share/texmf/dvips/xcolor

    #latex xcolor.dtx
    #latex xcolor.dtx
    #makeindex -s gind.ist xcolor.idx
    #latex xcolor.dtx
    #latex xcolor.dtx

    rm *.sty *.pro *.ins *.def *.dtx
    ensureDir $out/share/texmf/doc/latex-xcolor
    cp *  $out/share/texmf/doc/latex-xcolor
  '') ["minInit" "doUnpack" "defEnsureDir" "addInputs"];

  meta = {
    description = "Extra components for TeXLive: LaTeX color support";
  };
}
