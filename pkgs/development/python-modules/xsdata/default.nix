{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  replaceVars,
  ruff,
  click,
  jinja2,
  toposort,
  typing-extensions,
  lxml,
  requests,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "xsdata";
  version = "26.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tefra";
    repo = "xsdata";
    tag = "v${version}";
    hash = "sha256-h5VGXGXQSG4o8H+Q+Z0SN9rw4mFI8EORNtB+4VAKg/k=";
  };

  patches = [
    (replaceVars ./paths.patch {
      ruff = lib.getExe ruff;
    })
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "--benchmark-skip" ""
  '';

  build-system = [ setuptools ];

  dependencies = [ typing-extensions ];

  optional-dependencies = {
    cli = [
      click
      jinja2
      toposort
    ];
    lxml = [ lxml ];
    soap = [ requests ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ lib.concatAttrValues optional-dependencies;

  disabledTestPaths = [ "tests/integration/benchmarks" ];

  pythonImportsCheck = [
    "xsdata.formats.dataclass.context"
    "xsdata.formats.dataclass.models.elements"
    "xsdata.formats.dataclass.models.generics"
    "xsdata.formats.dataclass.parsers"
    "xsdata.formats.dataclass.parsers.handlers"
    "xsdata.formats.dataclass.parsers.nodes"
    "xsdata.formats.dataclass.serializers"
    "xsdata.formats.dataclass.serializers.config"
    "xsdata.formats.dataclass.serializers.mixins"
    "xsdata.formats.dataclass.serializers.writers"
    "xsdata.models.config"
    "xsdata.utils.text"
  ];

  meta = {
    description = "Naive XML & JSON bindings for Python";
    mainProgram = "xsdata";
    homepage = "https://github.com/tefra/xsdata";
    changelog = "https://github.com/tefra/xsdata/blob/${src.tag}/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
