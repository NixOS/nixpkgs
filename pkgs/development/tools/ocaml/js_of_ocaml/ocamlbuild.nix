{ lib, buildDunePackage, fetchFromGitHub
, ocamlbuild
}:

buildDunePackage rec {
  pname = "js_of_ocaml-ocamlbuild";
  version = "4.0.0";

  minimalOCamlVersion = "4.02";

  src = fetchFromGitHub {
    owner = "ocsigen";
    repo = pname;
    rev = "852302c8f35b946e2ec275c529a79e46d8749be6";
    sha256 = "sha256:03ayvakvbh4wi4dwcgd7r9y8ka8cv3d59hb81yk2dxyd94bln145";
  };

  propagatedBuildInputs = [ ocamlbuild ];

  meta = {
    description = "An ocamlbuild plugin to compile to JavaScript";
    license = lib.licenses.lgpl2Only;
    maintainers = [ lib.maintainers.vbgl ];
    inherit (src.meta) homepage;
  };
}
