{ stdenv, fetchzip, ocamlPackages }:

stdenv.mkDerivation rec
{
  pname = "ocsigen-i18n";
  version = "3.5.0";

  buildInputs = with ocamlPackages; [ ocaml findlib ppx_tools ];

  dontStrip = true;

  installPhase = ''
    mkdir -p $out/bin
    make bindir=$out/bin install
  '';

  src = fetchzip {
    url = "https://github.com/besport/${pname}/archive/${version}.tar.gz";
    sha256 = "1qsgwfl64b53w235wm7nnchqinzgsvd2gb52xm0kra2wlwp69rfq";
  };

  meta = {
    homepage = https://github.com/besport/ocsigen-i18n;
    description = "I18n made easy for web sites written with eliom";
    license = stdenv.lib.licenses.lgpl21;
    maintainers = [ stdenv.lib.maintainers.gal_bolle ];
  };

}
