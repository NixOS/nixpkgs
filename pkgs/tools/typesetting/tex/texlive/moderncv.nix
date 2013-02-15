args: with args;
rec {
  version = "1.3.0";
  name = "moderncv-${version}";
  src = fetchurl {
    url = "https://launchpad.net/moderncv/trunk/${version}/+download/moderncv-${version}.zip";
    sha256 = "0wdj90shi04v97b2d6chhvm9qrp0bcvsm46441730ils1y74wisq";
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
