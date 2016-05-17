args @ {texLive, unzip, ...}: with args;
rec {
  version = "0.9";
  name = "moderntimeline-${version}";
  src = fetchurl {
    url = "https://github.com/raphink/moderntimeline/archive/v0.9.zip";
    sha256 = "1h1sfdh0whb74y6f999hs80flwpdbs2n4n2b9c450rvs1y7abcml";
  };

  buildInputs = [texLive unzip];
  phaseNames = ["doCopy"];
  doCopy = fullDepEntry (''
    mkdir -p $out/texmf-dist/tex/latex/moderntimeline $out/texmf-dist/doc/moderntimeline $out/share
    mv *.dtx *.ins $out/texmf-dist/tex/latex/moderntimeline/
    mv *.md $out/texmf-dist/doc/moderntimeline/
    ln -s $out/texmf* $out/share/
  '') ["minInit" "addInputs" "doUnpack" "defEnsureDir"];

  meta = {
    description = "the moderntimeline extensions for moderncv";
    # Actually, arch-independent..
    hydraPlatforms = [];
  };
}
