args: with args;
rec {
  version = "1.5.1";
  name = "moderncv-${version}";
  src = fetchurl {
    url = "https://launchpad.net/moderncv/trunk/${version}/+download/moderncv-${version}.zip";
    sha256 = "0k26s0z8hmw3h09vnpndim7gigwh8q6n9nbbihb5qbrw5qg2yqck";
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
