args: with args;
rec {
  name = "texlive-cm-super-2009";
  src = fetchurl {
    url = mirror://debian/pool/main/c/cm-super/cm-super_0.3.4.orig.tar.gz;
    sha256 = "0zrq4sr9ank35svkz3cfd7f978i9c8xbzdqm2c8kvxia2753v082";
  };

  phaseNames = ["doCopy"];
  doCopy = fullDepEntry (''
    mkdir -p $out/share/

    mkdir -p $out/texmf-dist/fonts/enc
    mkdir -p $out/texmf-dist/fonts/map
    mkdir -p $out/texmf-dist/fonts/type1/public/cm-super
    cp pfb/*.pfb $out/texmf-dist/fonts/type1/public/cm-super
    mkdir -p $out/texmf-dist/dvips/cm-super
    cp dvips/*.{map,enc}  $out/texmf-dist/dvips/cm-super
    cp dvips/*.enc  $out/texmf-dist/fonts/enc
    cp dvips/*.map  $out/texmf-dist/fonts/map
    mkdir -p $out/texmf-dist/dvipdfm/config
    cp dvipdfm/*.map  $out/texmf-dist/dvipdfm/config

    ln -s $out/texmf* $out/share/
  '') ["minInit" "doUnpack" "defEnsureDir" "addInputs"];
  buildInputs = [texLive];

  meta = {
    description = "Extra components for TeXLive: CM-Super fonts";
    maintainers = [ args.lib.maintainers.raskin ];

    # Actually, arch-independent.. 
    hydraPlatforms = [];
  };
}
