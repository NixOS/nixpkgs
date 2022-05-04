{ lib, buildPythonPackage, fetchFromGitHub, pythonOlder
, colorama, regex
, pytest-runner, pytestCheckHook, pytest-mypy
}:

buildPythonPackage rec {
  pname = "tatsu";
  version = "5.8.0";
  # upstream only supports 3.10+
  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "neogeny";
    repo = "TatSu";
    rev = "v${version}";
    sha256 = "sha256-spTIHiyspjrIV8DKR7YNpNTNO9SlcLOROuABhmu3ckA=";
  };

  nativeBuildInputs = [ pytest-runner ];
  propagatedBuildInputs = [ colorama regex ];
  checkInputs = [ pytestCheckHook pytest-mypy ];

  pythonImportsCheck = [ "tatsu" ];

  meta = with lib; {
    description = "Generates Python parsers from grammars in a variation of EBNF";
    longDescription = ''
      TatSu (the successor to Grako) is a tool that takes grammars in a
      variation of EBNF as input, and outputs memoizing (Packrat) PEG parsers in
      Python.
    '';
    homepage = "https://tatsu.readthedocs.io/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ primeos ];
  };

}
