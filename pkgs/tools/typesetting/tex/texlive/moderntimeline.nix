args: with args;
rec {
  version = "0.8";
  name = "moderntimeline-${version}";
  src = fetchurl {
    urls = [
      "http://www.ctan.org/tex-archive/macros/latex/contrib/moderntimeline.zip"
      "http://mirror.ctan.org/macros/latex/contrib/moderntimeline.zip"
    ];
    sha256 = "0y2m0qd0izrfjcwrmf3nvzkqmrhkdhzbv29s4c0knksdnfgcchc8";
  };

  buildInputs = [texLive unzip];
  phaseNames = ["doCopy"];
  doCopy = fullDepEntry (''
    mkdir -p $out/texmf-dist/tex/latex/moderntimeline $out/texmf-dist/doc/moderntimeline $out/share
    mv *.dtx *.ins $out/texmf-dist/tex/latex/moderntimeline/
    mv *.pdf $out/texmf-dist/doc/moderntimeline/
    ln -s $out/texmf* $out/share/
  '') ["minInit" "addInputs" "doUnpack" "defEnsureDir"];

  meta = {
    description = "the moderntimeline extensions for moderncv";
    maintainers = [ args.lib.maintainers.simons ];

    # Actually, arch-independent..
    hydraPlatforms = [];
  };
}
