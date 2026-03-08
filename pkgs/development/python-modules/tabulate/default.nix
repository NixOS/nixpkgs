{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
  setuptools,
  wcwidth,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  version = "0.9.0";
  pname = "tabulate";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "astanin";
    repo = "python-tabulate";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GZRmmKWmAeQkDo56fc2kWZiUjfips1x1e11MoYwZLgU=";
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
  ++ lib.concatAttrValues finalAttrs.finalPackage.optional-dependencies;

  # Tests against stdlib behavior which changed in https://github.com/python/cpython/pull/139070
  disabledTests = [
    "test_wrap_multiword_non_wide"
  ];

  meta = {
    description = "Pretty-print tabular data";
    mainProgram = "tabulate";
    homepage = "https://github.com/astanin/python-tabulate";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
})
