{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  lxml,
  pytestCheckHook,
  nose,
}:

buildPythonPackage rec {
  pname = "svgutils";
  version = "0.3.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "btel";
    repo = "svg_utils";
    rev = "refs/tags/v${version}";
    hash = "sha256-ITvZx+3HMbTyaRmCb7tR0LKqCxGjqDdV9/2taziUD0c=";
  };

  build-system = [ setuptools ];

  dependencies = [ lxml ];

  doCheck = pythonOlder "3.12";

  nativeCheckInputs = [
    pytestCheckHook
    nose
  ];

  pythonImportsCheck = [ "svgutils" ];

  meta = with lib; {
    description = "Python tools to create and manipulate SVG files";
    homepage = "https://github.com/btel/svg_utils";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
