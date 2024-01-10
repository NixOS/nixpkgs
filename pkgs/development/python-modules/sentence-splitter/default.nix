{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub

, pytestCheckHook
, regex
}:

buildPythonPackage rec {
  pname = "sentence-splitter";
  version = "1.4";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "mediacloud";
    repo = "sentence-splitter";
    rev = version;
    hash = "sha256-FxRi8fhKB9++lCTFpCAug0fxjkSVTKChLY84vkshR34=";
  };

  propagatedBuildInputs = [
    regex
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "sentence_splitter"
  ];

  meta = with lib; {
    description = "Text to sentence splitter using heuristic algorithm by Philipp Koehn and Josh Schroeder";
    homepage = "https://github.com/mediacloud/sentence-splitter";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ paveloom ];
  };
}
