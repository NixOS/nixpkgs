args: with args;
rec {
  name = "texlive-extra-2007";
  src = fetchurl {
    url = mirror://debian/pool/main/t/texlive-extra/texlive-extra_2007.dfsg.17.orig.tar.gz;
    sha256 = "093i40616vphyxycdi4z55sd2m0qfjypgprm7v182mgf55i2hpzc";
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
