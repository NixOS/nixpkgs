args: with args;
rec {
  name = "texlive-cm-super-2009";
  src = fetchurl {
    url = mirror://debian/pool/main/c/cm-super/cm-super_0.3.4.orig.tar.gz;
    sha256 = "0zrq4sr9ank35svkz3cfd7f978i9c8xbzdqm2c8kvxia2753v082";
  };

  phaseNames = ["doCopy"];
  doCopy = fullDepEntry (''
    ensureDir $out/share/texmf/fonts/enc
    ensureDir $out/share/texmf/fonts/map
    ensureDir $out/share/texmf/fonts/type1/public/cm-super
    cp pfb/*.pfb $out/share/texmf/fonts/type1/public/cm-super
    ensureDir $out/share/texmf/dvips/cm-super
    cp dvips/*.{map,enc}  $out/share/texmf/dvips/cm-super
    cp dvips/*.enc  $out/share/texmf/fonts/enc
    cp dvips/*.map  $out/share/texmf/fonts/map
    ensureDir $out/share/texmf/dvipdfm/config
    cp dvipdfm/*.map  $out/share/texmf/dvipdfm/config

    ln -s $out/share/texmf* $out/
  '') ["minInit" "doUnpack" "defEnsureDir" "addInputs"];
  buildInputs = [texLive];

  meta = {
    description = "Extra components for TeXLive: CM-Super fonts";
    maintainers = [ args.lib.maintainers.raskin ];

    # Actually, arch-independent.. 
    platforms = [] ;
  };
}
