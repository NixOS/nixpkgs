{ lib, fetchzip, buildDunePackage, cmdliner }:

buildDunePackage rec {
  version = "1.8.1";
  pname = "ocp-indent";

  src = fetchzip {
    url = "https://github.com/OCamlPro/ocp-indent/archive/${version}.tar.gz";
    sha256 = "0h4ysh36q1fxc40inhsdq2swqpfm15lpilqqcafs5ska42pn7s68";
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
