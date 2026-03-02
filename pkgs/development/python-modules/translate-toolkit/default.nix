{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools-scm,

  # dependencies
  unicode-segmentation-rs,
  urllib3,
  tomlkit,
  lxml,

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

buildPythonPackage rec {
  pname = "translate-toolkit";
  version = "3.18.1";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "translate";
    repo = "translate";
    tag = version;
    hash = "sha256-T7Zo2/jx9P+Tz8jwRKRCV1lVv7XIaIoQTIjIVdEj/ZQ=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    unicode-segmentation-rs
    urllib3
    lxml
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
    changelog = "https://docs.translatehouse.org/projects/translate-toolkit/en/latest/releases/${src.tag}.html";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ erictapen ];
  };
}
