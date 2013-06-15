args: with args;
rec {
  version = "0.7";
  name = "moderntimeline-${version}";
  src = fetchurl {
    url = "http://www.ctan.org/tex-archive/macros/latex/contrib/moderntimeline.zip";
    sha256 = "0dxwybanj7qvbr69wgsllha1brq6qjsnjfff6nw4r3nijzvvh876";
  };

  buildInputs = [texLive unzip];
  phaseNames = ["doCopy"];
  doCopy = fullDepEntry (''
    mkdir -p $out/texmf/tex/latex/moderntimeline $out/texmf/doc/moderntimeline $out/share
    mv *.dtx *.ins $out/texmf/tex/latex/moderntimeline/
    mv *.pdf $out/texmf/doc/moderntimeline/
    ln -s $out/texmf* $out/share/
  '') ["minInit" "addInputs" "doUnpack" "defEnsureDir"];

  meta = {
    description = "the moderntimeline extensions for moderncv";
    maintainers = [ args.lib.maintainers.simons ];

    # Actually, arch-independent..
    platforms = [] ;
  };
}
