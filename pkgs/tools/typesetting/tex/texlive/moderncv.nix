args: with args;
rec {
  name = "moderncv-0.19";
  src = fetchurl {
    url = "http://mirror.ctan.org/macros/latex/contrib/moderncv.zip";
    sha256 = "5cd2117cd2a3572dbc055033ca81ca744ee65918c42d23687e133bb1e6ddd644";
  };

  buildInputs = [texLive unzip];
  phaseNames = ["doCopy"];
  doCopy = fullDepEntry (''
    ensureDir $out/texmf/tex/latex/moderncv $out/texmf/doc $out/share
    mv *.cls *.sty $out/texmf/tex/latex/moderncv/
    mv examples $out/texmf/doc/moderncv
    ln -s $out/texmf* $out/share/
  '') ["minInit" "addInputs" "doUnpack" "defEnsureDir"];

  meta = {
    description = "the moderncv class for TeXLive";
    maintainers = [ args.lib.maintainers.simons ];

    # Actually, arch-independent..
    platforms = [] ;
  };
}
