args: with args;
rec {
  version = "1.1.1";
  name = "moderncv-${version}";
  src = fetchurl {
    url = "https://launchpad.net/moderncv/trunk/${version}/+download/moderncv-${version}.zip";
    sha256 = "929c118eff339a5c59ed58cc961ddee787e9a5933d12ec8801613fd2e2500e9f";
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
