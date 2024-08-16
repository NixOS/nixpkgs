{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "wcwidth";
  version = "0.2.13";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-cuoMBjmesobZeP3ttpI6nrR+HEhs5j6bTmT8GDA5crU=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  # To prevent infinite recursion with pytest
  doCheck = false;

  pythonImportsCheck = [ "wcwidth" ];

  meta = with lib; {
    description = "Measures number of Terminal column cells of wide-character codes";
    longDescription = ''
      This API is mainly for Terminal Emulator implementors -- any Python
      program that attempts to determine the printable width of a string on
      a Terminal. It is implemented in python (no C library calls) and has
      no 3rd-party dependencies.
    '';
    homepage = "https://github.com/jquast/wcwidth";
    changelog = "https://github.com/jquast/wcwidth/releases/tag/${version}";
    license = licenses.mit;
    maintainers = [ ];
  };
}
