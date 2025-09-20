{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  cmdliner,
  findlib,
}:

buildDunePackage rec {
  version = "1.8.2";
  pname = "ocp-indent";

  duneVersion = "3";

  src = fetchFromGitHub {
    owner = "OCamlPro";
    repo = "ocp-indent";
    rev = version;
    sha256 = "sha256-IyvURw/6R0eKrnahV1fqLV0iIeypykrmxDbliECgbLc=";
  };

  minimalOCamlVersion = "4.03";

  buildInputs = [ cmdliner ];
  propagatedBuildInputs = [ findlib ];

  meta = {
    homepage = "https://www.typerex.org/ocp-indent.html";
    description = "Customizable tool to indent OCaml code";
    mainProgram = "ocp-indent";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.jirkamarsik ];
  };
}
