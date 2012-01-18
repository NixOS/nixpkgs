args: with args;
rec {
  name = "texlive-beamer-2007";
  src = fetchurl {
    url = mirror://debian/pool/main/l/latex-beamer/latex-beamer_3.07.orig.tar.gz;
    sha256 = "07ldhg5f0hcnhjgzg5g8ailqacn8zhqc8nl2jkxc43c2qxbvswbv";
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
