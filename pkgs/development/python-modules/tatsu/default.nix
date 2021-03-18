{ lib, buildPythonPackage, fetchFromGitHub, pythonOlder
, colorama, mypy, pyyaml, regex
, dataclasses, typing
, pytestrunner, pytest-mypy
}:

buildPythonPackage rec {
  pname = "TatSu";
  version = "5.5.0";

  src = fetchFromGitHub {
    owner = "neogeny";
    repo = pname;
    rev = "v${version}";
    sha256 = "07bmdnwh99p60cgzhlb8s5vwi5v4r5zi8shymxnnarannkc66hzn";
  };

  disabled = pythonOlder "3.8";

  nativeBuildInputs = [ pytestrunner ];
  propagatedBuildInputs = [ colorama mypy pyyaml regex ]
    ++ lib.optionals (pythonOlder "3.7") [ dataclasses ]
    ++ lib.optionals (pythonOlder "3.5") [ typing ];
  checkInputs = [ pytest-mypy ];

  checkPhase = ''
    pytest test/
  '';

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
