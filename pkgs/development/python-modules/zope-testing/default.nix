{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  isPyPy,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "zope-testing";
  version = "5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zopefoundation";
    repo = "zope.testing";
    tag = version;
    hash = "sha256-G9RfRsXSzQ92HeBF5dRTI+1XEz1HM3DuB0ypZ61uHfw=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools <= 75.6.0" setuptools
  '';

  build-system = [ setuptools ];

  doCheck = !isPyPy;

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "src/zope/testing/tests.py" ];

  pythonImportsCheck = [ "zope.testing" ];

  pythonNamespaces = [ "zope" ];

  meta = {
    description = "Zope testing helpers";
    homepage = "https://github.com/zopefoundation/zope.testing";
    changelog = "https://github.com/zopefoundation/zope.testing/blob/${version}/CHANGES.rst";
    license = lib.licenses.zpl21;
    maintainers = [ ];
  };
}
