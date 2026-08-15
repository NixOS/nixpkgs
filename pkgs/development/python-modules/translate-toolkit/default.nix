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
  syrupy,
}:

buildPythonPackage (finalAttrs: {
  pname = "translate-toolkit";
  version = "3.19.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "translate";
    repo = "translate";
    tag = finalAttrs.version;
    hash = "sha256-+94oo6IYnRR4jnR60C3WNjesK6Tk6jND3xsYyx6sw0U=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    lxml
    unicode-segmentation-rs
  ];

  pythonRelaxDeps = [ "lxml" ];

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
    syrupy
    gettext
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  disabledTests = [
    # Probably breaks because of nix sandbox
    "test_timezones"
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
