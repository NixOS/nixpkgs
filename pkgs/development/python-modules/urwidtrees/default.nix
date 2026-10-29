{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  setuptools,
  urwid,
}:

buildPythonPackage (finalAttrs: {
  pname = "urwidtrees";
  version = "1.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pazz";
    repo = "urwidtrees";
    tag = finalAttrs.version;
    hash = "sha256-MQy2b0Q3gTbY8lmmt39Z1Nix0UpQtj+14T/zE1F/YJ4=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ urwid ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "urwidtrees" ];

  meta = {
    description = "Tree widgets for urwid";
    homepage = "https://github.com/pazz/urwidtrees";
    changelog = "https://github.com/pazz/urwidtrees/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
  };
})
