# when changing this expression convert it from 'fetchzip' to 'stdenvNoCC.mkDerivation'
{lib, fetchzip}:

let
  version = "3.5";
in (fetchzip {
  name = "jost-${version}";
  url = "https://github.com/indestructible-type/Jost/releases/download/${version}/Jost.zip";

  sha256="0l78vhmbsyfmrva5wc76pskhxqryyg8q5xddpj9g5wqsddy525dq";

  meta = with lib; {
    homepage = "https://github.com/indestructible-type/Jost";
    description = "A sans serif font by Indestructible Type";
    license = licenses.ofl;
    maintainers = [ maintainers.ar1a ];
  };
}).overrideAttrs (_: {
  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile \*.otf -d $out/share/fonts/opentype
  '';
})
