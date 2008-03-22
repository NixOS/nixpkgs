args: with args;
rec {
  name = "texlive-pgf-2007";
  src = fetchurl {
    url = http://ftp.de.debian.org/debian/pool/main/p/pgf/pgf_1.18.orig.tar.gz;
    sha256 = "1fk0m3rqsgdrxp2n6mbhh92819g1133w67lbgk66pqgspbrnk6h2";
  };

  propagatedBuildInputs = [texLiveLatexXColor texLive];

  phaseNames = ["doCopy"];
  doCopy = FullDepEntry (''
    ensureDir $out/share/texmf/tex/generic/pgf
    cp -r * $out/share/texmf/tex/generic/pgf
  '') ["minInit" "doUnpack" "defEnsureDir" "addInputs"];

  meta = {
    description = "Extra components for TeXLive: graphics package";
  };
}
