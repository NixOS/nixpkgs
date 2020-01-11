{ stdenv, fetchFromGitHub, buildDunePackage, ocp-build, ocp-indent, cmdliner, re,  }:

buildDunePackage rec {
  pname = "ocp-index";
  version = "1.1.9";

  src = fetchFromGitHub {
    owner = "OCamlPro";
    repo = pname;
    rev = version;
    sha256 = "0dq1kap16xfajc6gg9hbiadax782winpvxnr3dkm2ncznnxds37p";
  };

  buildInputs = [ ocp-build cmdliner re ];

  propagatedBuildInputs = [ ocp-indent ];

  meta = {
    homepage = http://typerex.ocamlpro.com/ocp-index.html;
    description = "A simple and light-weight documentation extractor for OCaml";
    license = stdenv.lib.licenses.lgpl3;
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
  };
}
