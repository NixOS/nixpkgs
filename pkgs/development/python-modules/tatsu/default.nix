{ lib, buildPythonPackage, fetchFromGitHub, pythonOlder
, colorama, regex
, pytest-runner, pytestCheckHook, pytest-mypy
}:

buildPythonPackage rec {
  pname = "tatsu";
  version = "5.7.1";
  # upstream only supports 3.10+
  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "neogeny";
    repo = "TatSu";
    rev = "v${version}";
    sha256 = "12ljff6l29q92625pgsg4f7xf4dz6iz1c3zdkzz188s4lnwpy8b8";
  };

  disabled = pythonOlder "3.8";

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
