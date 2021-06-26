{ lib
, buildPythonPackage
, fetchPypi
, six
, setuptools-scm
, toml
}:

buildPythonPackage rec {
  pname = "singledispatch";
  version = "3.6.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d5bb9405a4b8de48e36709238e8b91b4f6f300f81a5132ba2531a9a738eca391";
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
