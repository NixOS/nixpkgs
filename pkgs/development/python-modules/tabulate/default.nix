{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools-scm,
  setuptools,
  wcwidth,
  pytestCheckHook,
}:

buildPythonPackage rec {
  version = "0.9.0";
  pname = "tabulate";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-AJWxK/WWbeUpwP6x+ghnFnGzNo7sd9fverEUviwGizw=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  optional-dependencies = {
    widechars = [ wcwidth ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ] ++ lib.flatten (builtins.attrValues optional-dependencies);

  meta = {
    description = "Pretty-print tabular data";
    mainProgram = "tabulate";
    homepage = "https://github.com/astanin/python-tabulate";
    license = lib.licenses.mit;
  };
}
