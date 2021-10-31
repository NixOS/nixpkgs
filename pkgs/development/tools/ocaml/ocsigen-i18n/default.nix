{ lib, stdenv, fetchFromGitHub, ocamlPackages }:

stdenv.mkDerivation rec {
  pname = "ocsigen-i18n";
  version = "3.7.0";

  buildInputs = with ocamlPackages; [ ocaml findlib ppx_tools ];

  dontStrip = true;

  installPhase = ''
    mkdir -p $out/bin
    make bindir=$out/bin install
  '';

  src = fetchFromGitHub {
    owner = "besport";
    repo = "ocsigen-i18n";
    rev = version;
    sha256 = "sha256-PmdDyn+MUcNFrZpP/KLGQzdXUFRr+dYRAZjTZxHSeaw=";
  };

  meta = {
    homepage = "https://github.com/besport/ocsigen-i18n";
    description = "I18n made easy for web sites written with eliom";
    license = lib.licenses.lgpl21;
    maintainers = [ lib.maintainers.gal_bolle ];
  };

}
