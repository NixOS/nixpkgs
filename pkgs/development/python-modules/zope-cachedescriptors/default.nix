{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "zope-cachedescriptors";
  version = "5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zopefoundation";
    repo = "zope.cachedescriptors";
    tag = version;
    hash = "sha256-2cb8XosPCAV2BfMisCN9mr0KIu5xcsLPIcPkmpeVT+k=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools <= 75.6.0" setuptools
  '';

  build-system = [ setuptools ];

  dependencies = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "src/zope/cachedescriptors/tests.py" ];

  pythonImportsCheck = [ "zope.cachedescriptors" ];

  pythonNamespaces = [ "zope" ];

  meta = {
    description = "Method and property caching decorators";
    homepage = "https://github.com/zopefoundation/zope.cachedescriptors";
    changelog = "https://github.com/zopefoundation/zope.cachedescriptors/blob/${version}/CHANGES.rst";
    license = lib.licenses.zpl21;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
