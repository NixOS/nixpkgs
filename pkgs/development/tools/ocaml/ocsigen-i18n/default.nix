{ stdenv, fetchurl, ocamlPackages }:

stdenv.mkDerivation rec
{
  name = "ocsigen-i18n";
  version = "3.1.0";

  buildInputs = with ocamlPackages; [ ocaml findlib ];

  installPhase = ''
    mkdir -p $out/bin
    make bindir=$out/bin install
  '';

  src = fetchurl {
    url = "https://github.com/besport/${name}/archive/${version}.tar.gz";
    sha256 = "0cw0mmr67wx03j4279z7ldxwb01smkqz9rbklx5lafrj5sf99178";
  };

  meta = {
    homepage = https://github.com/besport/ocsigen-i18n;
    description = "I18n made easy for web sites written with eliom";
    license = stdenv.lib.licenses.lgpl21;
    maintainers = [ stdenv.lib.maintainers.gal_bolle ];
  };

}
