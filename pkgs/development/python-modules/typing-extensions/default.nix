{ buildPythonPackage
, fetchPypi
, lib
, python
, typing
, flit-core
}:

buildPythonPackage rec {
  pname = "typing_extensions";
  version = "4.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-TKCR3qFJ+UXsVq+0ja5xTyHoaS7yKjlSI7zTKJYbag4=";
  };

  format = "pyproject";

  nativeBuildInputs = [ flit-core ];

  checkInputs = [ typing ];

  doCheck = true;

  checkPhase = ''
    cd src
    ${python.interpreter} -m unittest discover
  '';

  meta = with lib; {
    description = "Backported and Experimental Type Hints for Python 3.5+";
    homepage = "https://github.com/python/typing";
    license = licenses.psfl;
    maintainers = with maintainers; [ pmiddend ];
  };
}
