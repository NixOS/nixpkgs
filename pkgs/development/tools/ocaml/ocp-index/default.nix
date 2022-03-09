{ lib, fetchFromGitHub, buildDunePackage, cppo, ocp-indent, cmdliner, re }:

buildDunePackage rec {
  pname = "ocp-index";
  version = "1.3.3";

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "OCamlPro";
    repo = "ocp-index";
    rev = version;
    sha256 = "sha256-ElCXjUR85tkyBLIpIKefDouE1upzJytQnk4xoQt/cb0=";
  };

  strictDeps = true;

  nativeBuildInputs = [ cppo ];
  buildInputs = [ cmdliner re ];

  propagatedBuildInputs = [ ocp-indent ];

  meta = {
    homepage = "https://www.typerex.org/ocp-index.html";
    description = "A simple and light-weight documentation extractor for OCaml";
    changelog = "https://github.com/OCamlPro/ocp-index/raw/${version}/CHANGES.md";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ vbgl ];
  };
}
