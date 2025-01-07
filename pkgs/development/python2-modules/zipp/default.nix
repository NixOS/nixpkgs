{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools-scm,
  pytest,
  pytest-flake8,
  more-itertools,
}:

buildPythonPackage rec {
  pname = "zipp";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0v3qayhqv7vyzydpydwcp51bqciw8p2ajddw68x5k8zppc0vx3yk";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [ more-itertools ];

  nativeCheckInputs = [
    pytest
    pytest-flake8
  ];

  checkPhase = ''
    pytest
  '';

  # Prevent infinite recursion with pytest
  doCheck = false;

  meta = {
    description = "Pathlib-compatible object wrapper for zip files";
    homepage = "https://github.com/jaraco/zipp";
    license = lib.licenses.mit;
  };
}
