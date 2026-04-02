{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools-scm,

  # dependencies
  lxml,
  unicode-segmentation-rs,
  urllib3,

  # optional-dependencies
  tomlkit,

  # tests
  aeidon,
  charset-normalizer,
  cheroot,
  fluent-syntax,
  gettext,
  iniparse,
  mistletoe,
  phply,
  pyparsing,
  pytestCheckHook,
  ruamel-yaml,
  syrupy,
  vobject,
}:

buildPythonPackage (finalAttrs: {
  pname = "translate-toolkit";
  version = "3.19.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "translate";
    repo = "translate";
    tag = finalAttrs.version;
    hash = "sha256-k+gCrY2r1ILeSvjdEHT3wE2LF9Qn76ENe9RRVcaHmq4=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    lxml
    unicode-segmentation-rs
    urllib3
  ];

  optional-dependencies = {
    toml = [ tomlkit ];
  };

  nativeCheckInputs = [
    aeidon
    charset-normalizer
    cheroot
    fluent-syntax
    gettext
    iniparse
    mistletoe
    phply
    pyparsing
    pytestCheckHook
    ruamel-yaml
    syrupy
    tomlkit
    vobject
  ];

  disabledTests = [
    # Probably breaks because of nix sandbox
    "test_timezones"

    # Requires network
    "test_xliff_conformance"
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
