{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
}:

buildPythonPackage rec {
  pname = "sybil";
  version = "10.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simplistix";
    repo = "sybil";
    tag = version;
    hash = "sha256-wRJ43CzatyP5VuCZSF+6Eh1kGmdNhbzDPoBHbV/96oo=";
  };

  build-system = [ hatchling ];

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
