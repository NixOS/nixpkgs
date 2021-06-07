{ lib, fetchzip, buildDunePackage, cppo, ocp-indent, cmdliner, re }:

buildDunePackage rec {
  pname = "ocp-index";
  version = "1.2.2";

  useDune2 = true;

  src = fetchzip {
    url = "https://github.com/OCamlPro/ocp-index/archive/${version}.tar.gz";
    sha256 = "0k4i0aabyn750f4wqbnk0yv10kdjd6nhjw2pbmpc4cz639qcsm40";
  };

  buildInputs = [ cppo cmdliner re ];

  propagatedBuildInputs = [ ocp-indent ];

  meta = {
    homepage = "https://www.typerex.org/ocp-index.html";
    description = "A simple and light-weight documentation extractor for OCaml";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ vbgl ];
  };
}
