args: with args;
rec {
  name = "texlive-beamer-2007";
  src = fetchurl {
    url = http://ftp.de.debian.org/debian/pool/main/l/latex-beamer/latex-beamer_3.07.orig.tar.gz;
    sha256 = "07ldhg5f0hcnhjgzg5g8ailqacn8zhqc8nl2jkxc43c2qxbvswbv";
  };

  buildInputs = [texLive];
  propagatedBuildInputs = [texLiveLatexXColor texLivePGF];
  phaseNames = ["doCopy"];
  doCopy = FullDepEntry (''
    ensureDir $out/share/texmf-dist/tex/latex/beamer
    cp -r * $out/share/texmf-dist/tex/latex/beamer 
  '') ["minInit" "doUnpack" "defEnsureDir" "addInputs"];

  meta = {
    description = "Extra components for TeXLive: beamer class";
  };
}
