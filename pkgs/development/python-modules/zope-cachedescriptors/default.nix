{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "zope-cachedescriptors";
<<<<<<< HEAD
  version = "6.0";
=======
  version = "5.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zopefoundation";
    repo = "zope.cachedescriptors";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-PlezUzuO4P/BOVT6Ll8dYIKssC/glmVd8SCM0afgNC0=";
=======
    hash = "sha256-2cb8XosPCAV2BfMisCN9mr0KIu5xcsLPIcPkmpeVT+k=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
<<<<<<< HEAD
      --replace-fail "setuptools ==" "setuptools >="
=======
      --replace-fail "setuptools <= 75.6.0" setuptools
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
