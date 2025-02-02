{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  cppo,
  ocp-indent,
  cmdliner,
  re,
}:

buildDunePackage rec {
  pname = "ocp-index";
  version = "1.3.6";

  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "OCamlPro";
    repo = "ocp-index";
    rev = version;
    hash = "sha256-EgRpC58NBVFO1w0xx11CnonatU2H7bECsEk6Y4c/odY=";
  };

  nativeBuildInputs = [ cppo ];
  buildInputs = [
    cmdliner
    re
  ];

  propagatedBuildInputs = [ ocp-indent ];

  meta = {
    homepage = "https://www.typerex.org/ocp-index.html";
    description = "Simple and light-weight documentation extractor for OCaml";
    changelog = "https://github.com/OCamlPro/ocp-index/raw/${version}/CHANGES.md";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ vbgl ];
  };
}
