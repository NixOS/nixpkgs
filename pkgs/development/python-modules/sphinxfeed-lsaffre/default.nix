{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  feedgen,
  python-dateutil,
  sphinx,
  pytestCheckHook,
  pytest-cov-stub,
}:

buildPythonPackage (finalAttrs: {
  pname = "sphinxfeed-lsaffre";
  version = "0.3.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lsaffre";
    repo = "sphinxfeed";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2hS8EzaUlxAqBT0R5NMYAuj3ZMPq+x5nqJnidQOAGfM=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    feedgen
    python-dateutil
    sphinx
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  pythonImportsCheck = [
    "sphinxfeed"
  ];

  meta = {
    description = "Automatically generates an RSS feed when a build is run";
    homepage = "https://github.com/lsaffre/sphinxfeed";
    changelog = "https://github.com/lsaffre/sphinxfeed/blob/${finalAttrs.src.tag}/CHANGELOG.rst";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.antonmosich ];
  };
})
