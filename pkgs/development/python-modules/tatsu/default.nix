{ stdenv, buildPythonPackage, fetchFromGitHub, pythonOlder
, colorama, mypy, pyyaml, regex
, dataclasses, typing
, pytestrunner, pytest-mypy
}:

buildPythonPackage rec {
  pname = "TatSu";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "neogeny";
    repo = pname;
    rev = "v${version}";
    sha256 = "1c16fcxf0xjkh5py9bnj6ljb9krhrj57mkwayl1w1dvzwl5lkgj3";
  };

  # Since version 5.0.0 only >=3.8 is officially supported, but ics is not
  # compatible with Python 3.8 due to aiohttp:
  disabled = pythonOlder "3.7";
  postPatch = ''
    substituteInPlace setup.py \
      --replace "python_requires='>=3.8'," "python_requires='>=3.7',"
  '';

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
