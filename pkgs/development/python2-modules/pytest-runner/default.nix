{ lib, buildPythonPackage, fetchPypi, setuptools-scm, pytest }:

buildPythonPackage rec {
  pname = "pytest-runner";
  version = "5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "96c7e73ead7b93e388c5d614770d2bae6526efd997757d3543fe17b557a0942b";
  };

  nativeBuildInputs = [ setuptools-scm pytest ];

  postPatch = ''
    rm pytest.ini
  '';

  checkPhase = ''
    py.test tests
  '';

  # Fixture not found
  doCheck = false;

  meta = with lib; {
    description = "Invoke py.test as distutils command with dependency resolution";
    homepage = "https://github.com/pytest-dev/pytest-runner";
    license = licenses.mit;
  };
}
