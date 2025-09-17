{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools-scm,

  # dependencies
  cwcwidth,
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
  version = "3.16.1";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "translate";
    repo = "translate";
    tag = version;
    hash = "sha256-AEMqnTnnbqNsVQY0eE2ATn2NbV9jVPtfCo3Lve7MEmg=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    cwcwidth
    lxml
  ];

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
