{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, fetchpatch
, click
, click-default-group
, docformatter
, jinja2
, toposort
, lxml
, requests
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "xsdata";
  version = "22.12";

  disabled = pythonOlder "3.7";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-o9Xxt7b/+MkW94Jcg26ihaTn0/OpTcu+0OY7oV3JRGY=";
  };

  patches = [
    # https://github.com/tefra/xsdata/pull/741
    (fetchpatch {
      name = "use-docformatter-1.5.1.patch";
      url = "https://github.com/tefra/xsdata/commit/040692db47e6e51028fd959c793e757858c392d7.patch";
      excludes = [ "setup.cfg" ];
      hash = "sha256-ncecMJLJUiUb4lB8ys+nyiGU/UmayK++o89h3sAwREQ=";
    })
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--benchmark-skip" ""
  '';

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
