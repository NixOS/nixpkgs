{ lib
, buildPythonPackage
, fetchPypi
, six
, setuptools-scm
, toml
}:

buildPythonPackage rec {
  pname = "singledispatch";
  version = "3.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "58b46ce1cc4d43af0aac3ac9a047bdb0f44e05f0b2fa2eec755863331700c865";
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
