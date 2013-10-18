args: with args;
rec {
  name = "texlive-extra-2013";
  src = fetchurl {
    url = mirror://debian/pool/main/t/texlive-extra/texlive-extra_2013.20131010.orig.tar.xz;
    sha256 = "1wciyjwp0swny22amwcnr6vvdwjy423856q7c3l1sd5b31xfbc18";
  };

  buildInputs = [texLive xz];
  phaseNames = ["doCopy"];
  doCopy = fullDepEntry (''
    mkdir -p $out/share
    cp -r texmf* $out/
    ln -s $out/texmf* $out/share
  '') ["minInit" "doUnpack" "defEnsureDir" "addInputs"];

  meta = {
    description = "Extra components for TeXLive";
    maintainers = [ args.lib.maintainers.raskin ];

    # Actually, arch-independent.. 
    platforms = [] ;
  };
}
