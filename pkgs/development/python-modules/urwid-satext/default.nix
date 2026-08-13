{
  lib,
  buildPythonPackage,
  fetchhg,
  setuptools,
  urwid,
}:

buildPythonPackage rec {
  pname = "urwid-satext";
  version = "0.8.0-unstable-2023-04-08";
  pyproject = true;

  src = fetchhg {
    url = "https://repos.goffi.org/urwid-satext";
    rev = "6689aa54b20cb38731c68d4d39d86d01d25c21fa";
    hash = "sha256-llCONyYV2kVVmT4EsugnW9j5X5PIeYEnnk4i5rQnE0w=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    urwid
  ];

  pythonImportsCheck = [
    "urwid_satext"
  ];

  # no pytest tests exist
  doCheck = false;

  # Default-added updateScript doesn't handle Mercurial sources
  passthru.updateScript = null;

  meta = {
    description = "SàT extension widgets for Urwid";
    homepage = "https://libervia.org";
    changelog = "https://repos.goffi.org/urwid-satext/file/${src.rev}/CHANGELOG";
    license = lib.licenses.lgpl3Plus;
    teams = with lib.teams; [ ngi ];
    maintainers = [ lib.maintainers.oluchitheanalyst ];
  };
}
