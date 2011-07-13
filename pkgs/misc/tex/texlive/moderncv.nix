args: with args;
rec {
  name = "moderncv-2007.05.28";
  src = fetchurl {
    url = "http://mirror.ctan.org/macros/latex/contrib/moderncv.zip";
    sha256 = "d479141e9ae6dad745b03af47541b1bf7d312613de42bb7984eb4b556854cb51";
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
    description = "Extra components for TeXLive";
    maintainers = [ args.lib.maintainers.simons ];

    # Actually, arch-independent..
    platforms = [] ;
  };
}
