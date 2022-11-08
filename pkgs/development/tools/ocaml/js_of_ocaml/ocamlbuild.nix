{ lib, buildDunePackage, fetchurl
, ocamlbuild
}:

buildDunePackage rec {
  pname = "js_of_ocaml-ocamlbuild";
  version = "5.0";

  minimalOCamlVersion = "4.02";

  src = fetchurl {
    url = "https://github.com/ocsigen/js_of_ocaml-ocamlbuild/releases/download/${version}/js_of_ocaml-ocamlbuild-${version}.tbz";
    sha256 = "sha256-qlm8vxzie8sqPrd6iiwf8X6d2+DyQOOhmMoc67ChwHs=";
  };

  propagatedBuildInputs = [ ocamlbuild ];

  meta = {
    description = "An ocamlbuild plugin to compile to JavaScript";
    homepage = "https://github.com/ocsigen/js_of_ocaml-ocamlbuild";
    license = lib.licenses.lgpl2Only;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
