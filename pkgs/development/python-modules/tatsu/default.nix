{ lib
, buildPythonPackage
, colorama
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, regex
}:

buildPythonPackage rec {
  pname = "tatsu";
  version = "5.8.3";
  format = "setuptools";

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "neogeny";
    repo = "TatSu";
    rev = "refs/tags/v${version}";
    hash = "sha256-cKEMRbH/xNtYM0lmNVazv3i0Q1tmVrVPrB6F2s02Sro=";
  };

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
