args: with args;
rec {
  name = "texlive-extra-2012";
  src = fetchurl {
    url = mirror://debian/pool/main/t/texlive-extra/texlive-extra_2012.20120611.orig.tar.xz;
    sha256 = "1wn2gwifb5ww6nb15zdbkk5yz5spynvwqscvrgxzb84p0z3hy8dq";
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
