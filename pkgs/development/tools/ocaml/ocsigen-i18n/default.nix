{ stdenv, fetchurl, ocamlPackages }:

stdenv.mkDerivation rec
{
  pname = "ocsigen-i18n";
  version = "3.4.0";

  buildInputs = with ocamlPackages; [ ocaml findlib ];


  dontStrip = true;

  installPhase = ''
    mkdir -p $out/bin
    make bindir=$out/bin install
  '';

  src = fetchurl {
    url = "https://github.com/besport/${pname}/archive/${version}.tar.gz";
    sha256 = "0i7cck6zlgwjpksb4s1jpy193h85jixf4d0nmqj09y3zcpn2i8gb";
  };

  meta = {
    homepage = https://github.com/besport/ocsigen-i18n;
    description = "I18n made easy for web sites written with eliom";
    license = stdenv.lib.licenses.lgpl21;
    maintainers = [ stdenv.lib.maintainers.gal_bolle ];
  };

}
