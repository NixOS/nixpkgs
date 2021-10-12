{ lib
, buildPythonPackage
, fetchPypi
, six
, setuptools-scm
, toml
}:

buildPythonPackage rec {
  pname = "singledispatch";
  version = "3.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c1a4d5c1da310c3fd8fccfb8d4e1cb7df076148fd5d858a819e37fffe44f3092";
  };

  nativeBuildInputs = [
    setuptools-scm
    toml
  ];

  propagatedBuildInputs = [ six ];

  # pypi singledispatch tarbal does not contain tests
  doCheck = false;

  meta = {
    description = "This library brings functools.singledispatch from Python 3.4 to Python 2.6-3.3.";
    homepage = "https://docs.python.org/3/library/functools.html";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ costrouc ];
  };
}
