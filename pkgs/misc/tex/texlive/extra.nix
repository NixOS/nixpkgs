args: with args;
rec {
  name = "texlive-extra-2007";
  src = fetchurl {
    url = mirror://debian/pool/main/t/texlive-extra/texlive-extra_2007.dfsg.1.orig.tar.gz;
    sha256 = "1440495dcsrwhnz1p1prs4rf84ca0v7fjwg7sdw7isnprnpiq7w5";
  };

  buildInputs = [texLive];
  phaseNames = ["doCopy"];
  doCopy = FullDepEntry (''
    ensureDir $out/share
    cp -r texmf* $out/share/
  '') ["minInit" "doUnpack" "defEnsureDir" "addInputs"];

  meta = {
    description = "Extra components for TeXLive";
  };
}
