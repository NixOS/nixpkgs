{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "sybil";
  version = "9.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simplistix";
    repo = "sybil";
    tag = version;
    hash = "sha256-rr6zVY1yJVL/s/Wg5S4pSljj9Zq+jo7CZ6TZvtPpxow=";
  };

  build-system = [ setuptools ];

  # Circular dependency with testfixtures
  doCheck = false;

  pythonImportsCheck = [ "sybil" ];

  meta = {
    description = "Automated testing for the examples in your documentation";
    homepage = "https://github.com/cjw296/sybil";
    changelog = "https://github.com/simplistix/sybil/blob/${src.tag}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
