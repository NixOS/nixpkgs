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
  version = "5.11.3";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "neogeny";
    repo = "TatSu";
    rev = "refs/tags/v${version}";
    hash = "sha256-5tVvElM7pZF3rZJMMk0IIZBhiv+9J8KBLjfoVTPF198=";
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
