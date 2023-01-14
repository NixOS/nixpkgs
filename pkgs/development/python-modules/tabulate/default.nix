{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools-scm
, setuptools
, wcwidth
, pytestCheckHook
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

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  passthru.optional-dependencies = {
    widechars = [ wcwidth ];
  };

  checkInputs = [
    pytestCheckHook
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  meta = {
    description = "Pretty-print tabular data";
    homepage = "https://github.com/astanin/python-tabulate";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
