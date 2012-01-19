args: with args;
rec {
  name = "moderncv-2012.01.16";
  src = fetchurl {
    url = "http://mirror.ctan.org/macros/latex/contrib/moderncv.zip";
    sha256 = "a9d2de7fc03c35c4084915b2788c8d7acfb695f9e27f6cd81427a7dd1a64cb54";
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
