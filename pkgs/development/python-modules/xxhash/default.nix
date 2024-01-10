{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
}:

buildPythonPackage rec {
  version = "3.3.0";
  format = "setuptools";
  pname = "xxhash";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-w/njIrHr7r1E49nS2bEk4MVQwe9BvVUq/c3XGVFu5Bo=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  meta = with lib; {
    homepage = "https://github.com/ifduyue/python-xxhash";
    description = "Python Binding for xxHash https://pypi.org/project/xxhash/";
    license = licenses.bsd2;
    maintainers = [ maintainers.teh ];
  };
}
