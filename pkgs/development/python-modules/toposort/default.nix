{ lib
, buildPythonPackage
, fetchPypi
, setuptools
}:

buildPythonPackage rec {
  pname = "toposort";
  version = "1.9";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-9Bo0SQ1Ek0tTOnva/5ee6KRyA/0tinRtuD8tWrEkWLk=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  pythonImportsCheck = [
    "toposort"
  ];

  meta = with lib; {
    description = "A topological sort algorithm";
    homepage = "https://pypi.python.org/pypi/toposort/";
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
    license = licenses.asl20;
  };
}
