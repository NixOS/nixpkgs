args: with args;
rec {
  name = "texlive-cm-super-2007";
  src = fetchurl {
    url = mirror://debian/pool/main/c/cm-super/cm-super_0.3.3.orig.tar.gz;
    sha256 = "1lxvnhqds2zi6ssz66r1b7s6p855lab7cgp0hdg247zkacbjxcfg";
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
  '') ["minInit" "doUnpack" "defEnsureDir" "addInputs"];
  buildInputs = [texLive];

  meta = {
    description = "Extra components for TeXLive: CM-Super fonts";
  };
}
