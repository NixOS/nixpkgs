{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatch-vcs,
  hatchling,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "termcolor";
  version = "2.5.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-mY2NJ9ptSEQujh8BYRkHa2kNliUHUx30iQ/NLbLvim8=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  pythonImportsCheck = [ "termcolor" ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    substituteInPlace pyproject.toml \
      --replace-fail ".ini_options" ""
  '';

  meta = with lib; {
    description = "ANSI color formatting for output in terminal";
    homepage = "https://github.com/termcolor/termcolor";
    license = licenses.mit;
  };
}
