{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  setuptools,
  urwid,
}:

buildPythonPackage rec {
  pname = "urwidtrees";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pazz";
    repo = "urwidtrees";
    tag = version;
    hash = "sha256-KmT/cQ9hQWMd0k6QNTrsAspNDSBYR9sE4//xIN+uL7w=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ urwid ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "urwidtrees" ];

  meta = {
    description = "Tree widgets for urwid";
    homepage = "https://github.com/pazz/urwidtrees";
    changelog = "https://github.com/pazz/urwidtrees/releases/tag/${src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
  };
}
