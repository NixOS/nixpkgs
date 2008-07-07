args: with args;
rec {
  name = "texlive-extra-2007";
  src = fetchurl {
    url = mirror://debian/pool/main/t/texlive-extra/texlive-extra_2007.dfsg.2.orig.tar.gz;
    sha256 = "1sdhidjafv5cls7r9g60qq3cw655kw91ms4may39pcm8wdbhqs77";
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
