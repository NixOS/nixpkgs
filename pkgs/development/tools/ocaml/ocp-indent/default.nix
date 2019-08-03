{ lib, fetchzip, buildDunePackage, cmdliner }:

buildDunePackage rec {
  version = "1.7.0";
  pname = "ocp-indent";

  src = fetchzip {
    url = "https://github.com/OCamlPro/ocp-indent/archive/${version}.tar.gz";
    sha256 = "006x3fsd61vxnxj4chlakyk3b2s10pb0bdl46g0ghf3j8h33x7hc";
  };

  minimumOCamlVersion = "4.02";

  buildInputs = [ cmdliner ];

  meta = with lib; {
    homepage = http://typerex.ocamlpro.com/ocp-indent.html;
    description = "A customizable tool to indent OCaml code";
    license = licenses.gpl3;
    maintainers = [ maintainers.jirkamarsik ];
  };
}
