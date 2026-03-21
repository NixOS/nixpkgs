{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  pytestCheckHook,
  regex,
}:

buildPythonPackage rec {
  pname = "sentence-splitter";
  version = "1.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "mediacloud";
    repo = "sentence-splitter";
    rev = version;
    hash = "sha256-FxRi8fhKB9++lCTFpCAug0fxjkSVTKChLY84vkshR34=";
  };

  propagatedBuildInputs = [ regex ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "sentence_splitter" ];

  meta = {
    description = "Text to sentence splitter using heuristic algorithm by Philipp Koehn and Josh Schroeder";
    homepage = "https://github.com/mediacloud/sentence-splitter";
    license = lib.licenses.lgpl3Plus;
    maintainers = [ ];
  };
}
