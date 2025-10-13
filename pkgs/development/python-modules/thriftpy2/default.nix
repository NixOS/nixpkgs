{
  lib,
  buildPythonPackage,
  cython,
  fetchFromGitHub,
  fetchpatch,
  ply,
  pythonOlder,
  six,
  setuptools,
  tornado,
}:

buildPythonPackage rec {
  pname = "thriftpy2";
  version = "0.5.3";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "Thriftpy";
    repo = "thriftpy2";
    tag = "v${version}";
    hash = "sha256-idUKqpyRj8lq9Aq6vEEeYEawzRPOdNsySnkgfhwPtMc=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/Thriftpy/thriftpy2/commit/0127d259eb4b96acb060cd158ca709f0597b148c.patch";
      hash = "sha256-UBcbd8NTkPyko1s9jTjKlQ7HprwtyOZS0m66u1CPH3A=";
    })
  ];
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
    changelog = "https://github.com/Thriftpy/thriftpy2/blob/${src.tag}/CHANGES.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
