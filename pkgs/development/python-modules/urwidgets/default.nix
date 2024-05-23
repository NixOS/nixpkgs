{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  urwid,
}:

buildPythonPackage rec {
  pname = "urwidgets";
  version = "0.2.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "AnonymouX47";
    repo = "urwidgets";
    rev = "refs/tags/v${version}";
    hash = "sha256-ultlfNeCGFTqKaMeXu0+NihkN5/6NtMewk33YfIzhu8=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ urwid ];

  pythonImportsCheck = [ "urwidgets" ];

  meta = with lib; {
    description = "A collection of widgets for urwid";
    homepage = "https://github.com/AnonymouX47/urwidgets";
    changelog = "https://github.com/AnonymouX47/urwidgets/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ huyngo ];
  };
}
