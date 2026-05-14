{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools-scm,

  # dependencies
  lxml,
  unicode-segmentation-rs,

  # optional-dependencies
  charset-normalizer,
  fluent-syntax,
  vobject,
  iniparse,
  rapidfuzz,
  mistletoe,
  phply,
  pyparsing,
  pyenchant,
  aeidon,
  tomlkit,
  ruamel-yaml,

  # tests
  pytestCheckHook,
  addBinToPathHook,
  pytest-xdist,
  gettext,
}:

buildPythonPackage (finalAttrs: {
  pname = "translate-toolkit";
  version = "3.19.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "translate";
    repo = "translate";
    tag = finalAttrs.version;
    hash = "sha256-NJuhkJyXfGO2iwvcHUrfMZi55t1+89RN6jEIxHk8mcs=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    lxml
    unicode-segmentation-rs
  ];

  optional-dependencies = {
    chardet = [ charset-normalizer ];
    fluent = [ fluent-syntax ];
    ical = [ vobject ];
    ini = [ iniparse ];
    levenshtein = [ rapidfuzz ];
    markdown = [ mistletoe ];
    php = [ phply ];
    rc = [ pyparsing ];
    spellcheck = [ pyenchant ];
    subtitles = [ aeidon ];
    toml = [ tomlkit ];
    yaml = [ ruamel-yaml ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    addBinToPathHook
    pytest-xdist
    gettext
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  disabledTests = [
    # Probably breaks because of nix sandbox
    "test_timezones"
  ];

  disabledTestPaths = [
    # Require pytest-snapshot but there are no snapshots checked in
    "tests/translate/tools/test_pocount.py"
    "tests/translate/tools/test_junitmsgfmt.py"
  ];

  pythonImportsCheck = [ "translate" ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Useful localization tools for building localization & translation systems";
    homepage = "https://toolkit.translatehouse.org/";
    changelog = "https://docs.translatehouse.org/projects/translate-toolkit/en/latest/releases/${finalAttrs.src.tag}.html";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ erictapen ];
  };
})
