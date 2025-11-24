{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  btrees,
  persistent,
  zope-interface,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "zope-index";
  version = "8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zopefoundation";
    repo = "zope.index";
    tag = "${version}";
    hash = "sha256-dHapd/+pJh6qzVx9FGSMmPsGbz8NhAoPqufXm3FOuM8=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools ==" "setuptools >="
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    btrees
    persistent
    zope-interface
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "zope.index"
  ];

  pythonNamespaces = [
    "zope"
  ];

  meta = {
    description = "Full-text indexing and searching for Zope";
    homepage = "https://github.com/zopefoundation/zope.index";
    changelog = "https://github.com/zopefoundation/zope.index/blob/${version}/CHANGES.rst";
    license = lib.licenses.zpl21;
    maintainers = with lib.maintainers; [ daniel-fahey ];
  };
}
