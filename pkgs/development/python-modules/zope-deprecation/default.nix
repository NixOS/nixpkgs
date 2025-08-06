{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "zope-deprecation";
  version = "5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zopefoundation";
    repo = "zope.deprecation";
    tag = version;
    hash = "sha256-5gqZuO3fGXkQl493QrvK7gl77mDteUp7tpo4DhSRI+o=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools <= 75.6.0" "setuptools"
  '';

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "src/zope/deprecation/tests.py" ];

  pythonImportsCheck = [ "zope.deprecation" ];

  pythonNamespaces = [ "zope" ];

  meta = {
    homepage = "https://github.com/zopefoundation/zope.deprecation";
    description = "Zope Deprecation Infrastructure";
    changelog = "https://github.com/zopefoundation/zope.deprecation/blob/${version}/CHANGES.rst";
    license = lib.licenses.zpl21;
    maintainers = with lib.maintainers; [ ];
  };
}
