{ lib, fetchFromGitHub, buildDunePackage, cmdliner }:

buildDunePackage rec {
  version = "1.8.2";
  pname = "ocp-indent";

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "OCamlPro";
    repo = "ocp-indent";
    rev = version;
    sha256 = "sha256-IyvURw/6R0eKrnahV1fqLV0iIeypykrmxDbliECgbLc=";
  };

  minimumOCamlVersion = "4.02";

  buildInputs = [ cmdliner ];

  meta = with lib; {
    homepage = "https://www.typerex.org/ocp-indent.html";
    description = "A customizable tool to indent OCaml code";
    license = licenses.gpl3;
    maintainers = [ maintainers.jirkamarsik ];
  };
}
