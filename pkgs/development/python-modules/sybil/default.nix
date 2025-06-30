{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "sybil";
  version = "9.1.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "simplistix";
    repo = "sybil";
    tag = version;
    hash = "sha256-ov8b8NPBbiqB/pcKgdD2D+xNSxUM1uGK8EP+20K7eGQ=";
  };

  build-system = [ setuptools ];

  # Circular dependency with testfixtures
  doCheck = false;

  pythonImportsCheck = [ "sybil" ];

  meta = with lib; {
    description = "Automated testing for the examples in your documentation";
    homepage = "https://github.com/cjw296/sybil";
    changelog = "https://github.com/simplistix/sybil/blob/${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = [ ];
  };
}
