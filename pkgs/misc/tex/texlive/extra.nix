args: with args;
rec {
  name = "texlive-extra-2009";
  src = fetchurl {
    url = mirror://debian/pool/main/t/texlive-extra/texlive-extra_2009.orig.tar.gz;
    sha256 = "04k48lxy76bad1270gb9k4aza2q13can2dbcf2hj0a3byls099kp";
  };

  buildInputs = [texLive];
  phaseNames = ["doCopy"];
  doCopy = fullDepEntry (''
    ensureDir $out/share
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
