{
  lib,
  buildPythonPackage,
  cython,
  fetchFromGitHub,
  ply,
  pythonOlder,
  six,
  setuptools,
  tornado,
}:

buildPythonPackage rec {
  pname = "thriftpy2";
  version = "0.5.2";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "Thriftpy";
    repo = "thriftpy2";
    rev = "refs/tags/v${version}";
    hash = "sha256-GBJL+IqZpT1/msJLiwiS5YDyB4hIe/e3pYPWx0A+lWY=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [ cython ];

  dependencies = [
    ply
    six
    tornado
  ];

  # Not all needed files seems to be present
  doCheck = false;

  pythonImportsCheck = [ "thriftpy2" ];

  meta = with lib; {
    description = "Python module for Apache Thrift";
    homepage = "https://github.com/Thriftpy/thriftpy2";
    changelog = "https://github.com/Thriftpy/thriftpy2/blob/v${version}/CHANGES.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
