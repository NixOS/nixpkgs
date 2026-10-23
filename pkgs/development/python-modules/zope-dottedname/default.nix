{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "zope-dottedname";
  version = "7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zopefoundation";
    repo = "zope.dottedname";
    tag = version;
    hash = "sha256-bWURUr+BCQsMNBYqJD2+YPdfA+FWrJuBGypQ/c8w6kA=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools ==" "setuptools >="
  '';

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "src/zope/dottedname/tests.py" ];

  pythonImportsCheck = [ "zope.dottedname" ];

  pythonNamespaces = [ "zope" ];

  meta = {
    homepage = "https://github.com/zopefoundation/zope.dottedname";
    description = "Resolver for Python dotted names";
    changelog = "https://github.com/zopefoundation/zope.dottedname/blob/${version}/CHANGES.rst";
    license = lib.licenses.zpl21;
    maintainers = [ ];
  };
}
