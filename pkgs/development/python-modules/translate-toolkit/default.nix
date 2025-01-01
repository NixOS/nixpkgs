{
  lib,
  fetchPypi,
  buildPythonPackage,
  setuptools-scm,
  lxml,
  wcwidth,
  pytestCheckHook,
  iniparse,
  vobject,
  mistletoe,
  phply,
  pyparsing,
  ruamel-yaml,
  cheroot,
  fluent-syntax,
  aeidon,
  charset-normalizer,
  syrupy,
  gettext,
}:

buildPythonPackage rec {
  pname = "translate-toolkit";
  version = "3.13.4";

  pyproject = true;
  build-system = [ setuptools-scm ];

  src = fetchPypi {
    pname = "translate_toolkit";
    inherit version;
    hash = "sha256-d0q4xpN37xeLSmQMBrDGZlGjAj4hHfkazGUHzl89UHI=";
  };

  dependencies = [
    lxml
    wcwidth
  ];

  nativeCheckInputs = [
    pytestCheckHook
    iniparse
    vobject
    mistletoe
    phply
    pyparsing
    ruamel-yaml
    cheroot
    fluent-syntax
    aeidon
    charset-normalizer
    syrupy
    gettext
  ];

  disabledTests = [
    # Probably breaks because of nix sandbox
    "test_timezones"
    # Requires network
    "test_xliff_conformance"
  ];

  pythonImportsCheck = [ "translate" ];

  meta = with lib; {
    description = "Useful localization tools for building localization & translation systems";
    homepage = "https://toolkit.translatehouse.org/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ erictapen ];
  };
}
