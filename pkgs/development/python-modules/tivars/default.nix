{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "tivars";
  version = "0.9.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-CK80zGDwLgnOI68k9GRlMcCLSBbkzdbG/CRC3mWdPw8=";
  };

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [ "tivars" ];

  meta = {
    description = "A Python library for interacting with TI-(e)z80 (82/83/84 series) calculator files";
    license = lib.licenses.mit;
    homepage = "https://ti-toolkit.github.io/tivars_lib_py/";
    changelog = "https://github.com/TI-Toolkit/tivars_lib_py/releases/tag/v${version}/CHANGELOG.md";
    maintainers = with lib.maintainers; [ ethancedwards8 ];
  };
}
