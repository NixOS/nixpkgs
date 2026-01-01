{
  lib,
  buildPythonPackage,
<<<<<<< HEAD
  fetchFromGitHub,
=======
  fetchPypi,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "zope-dottedname";
<<<<<<< HEAD
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

=======
  version = "6.0";
  pyproject = true;

  src = fetchPypi {
    pname = "zope.dottedname";
    inherit version;
    hash = "sha256-28S4W/vzSx74jasWJSrG7xbZBDnyIjstCiYs9Bnq6QI=";
  };

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
