args: with args;
rec {
  name = "texlive-beamer-2012";
  src = fetchurl {
    url = mirror://debian/pool/main/l/latex-beamer/latex-beamer_3.10.orig.tar.gz;
    sha256 = "1vk7nr1lxinyj941nz5xzcpzircd60s8sgmq7jd2gqmf5ynd27nx";
  };

  buildInputs = [texLive];
  propagatedBuildInputs = [texLiveLatexXColor texLivePGF];
  phaseNames = ["doCopy"];
  doCopy = fullDepEntry (''
    mkdir -p $out/share/

    mkdir -p $out/texmf-dist/tex/latex/beamer
    cp -r * $out/texmf-dist/tex/latex/beamer 

    ln -s $out/texmf* $out/share/
  '') ["minInit" "doUnpack" "defEnsureDir" "addInputs"];

  meta = {
    description = "Extra components for TeXLive: beamer class";
  };
}
