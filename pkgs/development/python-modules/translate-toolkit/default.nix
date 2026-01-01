{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools-scm,

  # dependencies
<<<<<<< HEAD
  unicode-segmentation-rs,
  urllib3,
  tomlkit,
=======
  cwcwidth,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
  version = "3.17.5";
=======
  version = "3.16.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  pyproject = true;

  src = fetchFromGitHub {
    owner = "translate";
    repo = "translate";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-I0HpVL/bH78oFGDWkXyRvZejXzjDHXFfdPu/+iMgAQw=";
=======
    hash = "sha256-AEMqnTnnbqNsVQY0eE2ATn2NbV9jVPtfCo3Lve7MEmg=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools-scm ];

  dependencies = [
<<<<<<< HEAD
    unicode-segmentation-rs
    urllib3
    lxml
  ];

  optional-dependencies = {
    toml = [ tomlkit ];
  };

=======
    cwcwidth
    lxml
  ];

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    tomlkit
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
