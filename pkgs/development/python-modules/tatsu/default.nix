{ stdenv, buildPythonPackage, fetchFromGitHub, pythonOlder
, colorama, mypy, pyyaml, regex
, dataclasses, typing
, pytestrunner, pytest-mypy
}:

buildPythonPackage rec {
  pname = "TatSu";
  version = "4.4.0";

  src = fetchFromGitHub {
    owner = "neogeny";
    repo = pname;
    rev = "v${version}";
    sha256 = "1jjd73yr3x56ij2ggxf6s62mf90i9v7wn3i0h67zxys55hlp2yh4";
  };

  nativeBuildInputs = [ pytestrunner ];
  propagatedBuildInputs = [ colorama mypy pyyaml regex ]
    ++ stdenv.lib.optionals (pythonOlder "3.7") [ dataclasses ]
    ++ stdenv.lib.optionals (pythonOlder "3.5") [ typing ];
  checkInputs = [ pytest-mypy ];

  checkPhase = ''
    pytest test/
  '';

  meta = with stdenv.lib; {
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
