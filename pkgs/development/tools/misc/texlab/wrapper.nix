# Texlab supports the following TeX Distributions:
# - TeX Live
# - MiKTeX
# - Tectonic

{ stdenvNoCC, lib, makeWrapper
, texlab-unwrapped, tex
}:

stdenvNoCC.mkDerivation {
  name = "texlab";
  inherit (texlab-unwrapped) version meta;

  phases = [ "installPhase" ];
  nativeBuildInputs = [ makeWrapper ];
  installPhase = ''
    makeWrapper ${texlab-unwrapped}/bin/texlab "$out/bin/texlab" \
      --prefix PATH : ${lib.makeBinPath [ tex ]}
  '';
}
