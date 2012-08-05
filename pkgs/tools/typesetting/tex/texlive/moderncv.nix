args: with args;
rec {
  name = "moderncv-1.1.1";
  src = fetchurl {
    url = "http://mirror.ctan.org/macros/latex/contrib/moderncv.zip";
    sha256 = "0krnyw1viyv72lixjpmjqwnx8rdmdazmad95jbyp7jy50454fsfd";
  };

  buildInputs = [texLive unzip];
  phaseNames = ["doCopy"];
  doCopy = fullDepEntry (''
    mkdir -p $out/texmf/tex/latex/moderncv $out/texmf/doc $out/share
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
