{ lib, fetchFromGitHub, ocamlPackages }:

ocamlPackages.buildDunePackage rec {
  pname = "ocsigen-i18n";
  version = "4.0.0";

  buildInputs = with ocamlPackages; [ ppxlib ];

  src = fetchFromGitHub {
    owner = "besport";
    repo = "ocsigen-i18n";
    rev = version;
    hash = "sha256-NIl1YUTws8Ff4nrqdhU7oS/TN0lxVQgrtyEZtpS1ojM=";
  };

  meta = {
    homepage = "https://github.com/besport/ocsigen-i18n";
    description = "I18n made easy for web sites written with eliom";
    license = lib.licenses.lgpl21;
    maintainers = [ lib.maintainers.gal_bolle ];
  };

}
