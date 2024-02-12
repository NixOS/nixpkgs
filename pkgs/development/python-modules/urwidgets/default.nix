{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, setuptools
, urwid
, wheel
}:

buildPythonPackage rec {
  pname = "urwidgets";
  version = "0.1.1";
  pyproject = true;
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "AnonymouX47";
    repo = "urwidgets";
    rev = "refs/tags/v${version}";
    hash = "sha256-0aZLL0NutptPkuLHv3bTzR1/SNqLgMdUYWET6mLE0IU=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    urwid
  ];

  pythonImportsCheck = [ "urwidgets" ];

  meta = with lib; {
    description = "A collection of widgets for urwid";
    homepage = "https://github.com/AnonymouX47/urwidgets";
    license = licenses.mit;
    maintainers = with maintainers; [ huyngo ];
  };
}
