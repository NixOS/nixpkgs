{ lib
, buildPythonPackage
, colorama
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, regex
, setuptools
}:

buildPythonPackage rec {
  pname = "tatsu";
  version = "5.12.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "neogeny";
    repo = "TatSu";
    rev = "refs/tags/v${version}";
    hash = "sha256-55sTUqNwfWg5h9msByq2RuVx/z23ST7p7pA/ZsIeYr8=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    colorama
    regex
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "tatsu"
  ];

  meta = with lib; {
    description = "Generates Python parsers from grammars in a variation of EBNF";
    longDescription = ''
      TatSu (the successor to Grako) is a tool that takes grammars in a
      variation of EBNF as input, and outputs memoizing (Packrat) PEG parsers in
      Python.
    '';
    homepage = "https://tatsu.readthedocs.io/";
    changelog = "https://github.com/neogeny/TatSu/releases/tag/v${version}";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
  };
}
