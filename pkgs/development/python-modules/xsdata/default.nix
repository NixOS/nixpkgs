{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
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
, wheel
}:

buildPythonPackage rec {
  pname = "xsdata";
  version = "23.8";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VfA9TIgjbwRyZq/+VQug3RlHat/OagHz4K76x8gHjlY=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "--benchmark-skip" ""
  '';

  nativeBuildInputs = [
    setuptools
    wheel
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
    description = "Python XML Binding";
    homepage = "https://github.com/tefra/xsdata";
    changelog = "https://github.com/tefra/xsdata/blob/v${version}/CHANGES.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
