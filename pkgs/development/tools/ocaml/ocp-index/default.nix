{ lib, fetchzip, buildDunePackage, cppo, ocp-indent, cmdliner, re }:

buildDunePackage rec {
  pname = "ocp-index";
  version = "1.2.1";

  src = fetchzip {
    url = "https://github.com/OCamlPro/ocp-index/archive/${version}.tar.gz";
    sha256 = "08r7mxdnxmhff37fw4hmrpjgckgi5kaiiiirwp4rmdl594z0h9c8";
  };

  buildInputs = [ cppo cmdliner re ];

  propagatedBuildInputs = [ ocp-indent ];

  meta = {
    homepage = "http://typerex.ocamlpro.com/ocp-index.html";
    description = "A simple and light-weight documentation extractor for OCaml";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ vbgl ];
  };
}
