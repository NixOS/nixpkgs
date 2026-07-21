{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "zope-cachedescriptors";
  version = "6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zopefoundation";
    repo = "zope.cachedescriptors";
    tag = version;
    hash = "sha256-PlezUzuO4P/BOVT6Ll8dYIKssC/glmVd8SCM0afgNC0=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools ==" "setuptools >="
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
