{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  urwid,
}:

buildPythonPackage rec {
  pname = "urwidgets";
  version = "0.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AnonymouX47";
    repo = "urwidgets";
    tag = "v${version}";
    hash = "sha256-RgY7m0smcdUspGkCdzepxruEMDq/mAsVFNjHMLoWAyc=";
  };

  build-system = [ setuptools ];

  dependencies = [ urwid ];

  pythonRelaxDeps = [ "urwid" ];

  pythonImportsCheck = [ "urwidgets" ];

  meta = with lib; {
    description = "Collection of widgets for urwid";
    homepage = "https://github.com/AnonymouX47/urwidgets";
    changelog = "https://github.com/AnonymouX47/urwidgets/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ huyngo ];
  };
}
