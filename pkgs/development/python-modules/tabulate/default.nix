{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools-scm,
  setuptools,
  wcwidth,
  pytestCheckHook,
}:

buildPythonPackage rec {
  version = "0.9.0";
  pname = "tabulate";
  pyproject = true;

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
  ]
  ++ lib.concatAttrValues optional-dependencies;

  # Tests against stdlib behavior which changed in https://github.com/python/cpython/pull/139070
  disabledTests = [
    "test_wrap_multiword_non_wide"
  ];

  meta = {
    description = "Pretty-print tabular data";
    mainProgram = "tabulate";
    homepage = "https://github.com/astanin/python-tabulate";
    license = lib.licenses.mit;
  };
}
