{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  cmdliner,
  findlib,
}:

buildDunePackage rec {
  version = "1.10.0";
  pname = "ocp-indent";

  src = fetchFromGitHub {
    owner = "OCamlPro";
    repo = "ocp-indent";
    tag = version;
    hash = "sha256-BJBweeWcOuiu82rp+QoLZ0QvGHAXXOJ5wkycfaxVXJQ=";
  };

  minimalOCamlVersion = "4.08";

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
