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
  version = "1.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pazz";
    repo = "urwidtrees";
    tag = version;
    hash = "sha256-MQy2b0Q3gTbY8lmmt39Z1Nix0UpQtj+14T/zE1F/YJ4=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ urwid ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "urwidtrees" ];

  meta = with lib; {
    description = "Tree widgets for urwid";
    homepage = "https://github.com/pazz/urwidtrees";
    changelog = "https://github.com/pazz/urwidtrees/releases/tag/${src.tag}";
    license = licenses.gpl3Plus;
    maintainers = [ ];
  };
}
