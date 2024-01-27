{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, substituteAll
, ruff
, click
, click-default-group
, docformatter
, jinja2
, toposort
, typing-extensions
, lxml
, requests
, pytestCheckHook
, setuptools
}:

buildPythonPackage rec {
  pname = "xsdata";
  version = "24.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "tefra";
    repo = "xsdata";
    rev = "v${version}";
    hash = "sha256-vdcCTJqvaRehGWfTd9GR/DypF9ftY4ite7SDMPc2Ups=";
  };

  patches = [
    (substituteAll {
      src = ./paths.patch;
      ruff = lib.getExe ruff;
    })
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "--benchmark-skip" ""
  '';

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    typing-extensions
  ];

  passthru.optional-dependencies = {
    cli = [
      click
      click-default-group
      docformatter
      jinja2
      toposort
    ];
    lxml = [
      lxml
    ];
    soap = [
      requests
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ] ++ passthru.optional-dependencies.cli
    ++ passthru.optional-dependencies.lxml
    ++ passthru.optional-dependencies.soap;

  disabledTestPaths = [
    "tests/integration/benchmarks"
  ];

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
    homepage = "https://github.com/tefra/xsdata";
    changelog = "https://github.com/tefra/xsdata/blob/${src.rev}/CHANGES.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
