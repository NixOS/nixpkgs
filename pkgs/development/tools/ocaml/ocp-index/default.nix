{ lib, fetchurl, buildDunePackage, ocp-build, ocp-indent, cmdliner, re }:

buildDunePackage rec {
  pname = "ocp-index";
  version = "1.2";

  src = fetchurl {
    url = "https://github.com/OCamlPro/ocp-index/releases/download/${version}/ocp-index-${version}.tbz";
    sha256 = "1lchw02sakjjppmzr0rzlarwbg1lc2bl7pwcfpsiycnaz46x6gmr";
  };

  buildInputs = [ ocp-build cmdliner re ];

  propagatedBuildInputs = [ ocp-indent ];

  meta = {
    homepage = http://typerex.ocamlpro.com/ocp-index.html;
    description = "A simple and light-weight documentation extractor for OCaml";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ vbgl ];
  };
}
