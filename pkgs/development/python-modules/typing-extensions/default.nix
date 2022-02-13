{ lib
, buildPythonPackage
, fetchPypi
, flit-core
, python
, pythonOlder
}:

buildPythonPackage rec {
  pname = "typing-extensions";
  version = "4.0.1";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "typing_extensions";
    inherit version;
    hash = "sha256-TKCR3qFJ+UXsVq+0ja5xTyHoaS7yKjlSI7zTKJYbag4=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  postPatch = ''
    # Remove metadata for README which are outdated
    sed -i -e '11,24d' pyproject.toml
  '';

  # Tests are not part of PyPI releases. GitHub source can't be used
  # as it ends with an infinite recursion
  doCheck = false;

  pythonImportsCheck = [
    "typing_extensions"
  ];

  meta = with lib; {
    description = "Backported and Experimental Type Hints for Python 3.5+";
    homepage = "https://github.com/python/typing";
    license = licenses.psfl;
    maintainers = with maintainers; [ pmiddend ];
  };
}
