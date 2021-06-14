{ lib, fetchzip, buildDunePackage, cmdliner }:

buildDunePackage rec {
  version = "1.8.2";
  pname = "ocp-indent";

  useDune2 = true;

  src = fetchzip {
    url = "https://github.com/OCamlPro/ocp-indent/archive/${version}.tar.gz";
    sha256 = "1dvcl108ir9nqkk4mjm9xhhj4p9dx9bmg8bnms54fizs1x3x8ar3";
  };

  minimumOCamlVersion = "4.02";

  buildInputs = [ cmdliner ];

  meta = with lib; {
    homepage = "http://typerex.ocamlpro.com/ocp-indent.html";
    description = "A customizable tool to indent OCaml code";
    license = licenses.gpl3;
    maintainers = [ maintainers.jirkamarsik ];
  };
}
