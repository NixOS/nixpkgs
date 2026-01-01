{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
<<<<<<< HEAD
  zope-testrunner,
=======
  pytestCheckHook,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildPythonPackage rec {
  pname = "zope-deprecation";
<<<<<<< HEAD
  version = "6.0";
=======
  version = "5.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zopefoundation";
    repo = "zope.deprecation";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-N/+RtilRY/8NfhUjd/Y4T6dmZHt6PW4ofP1UE8Aj1e8=";
=======
    hash = "sha256-5gqZuO3fGXkQl493QrvK7gl77mDteUp7tpo4DhSRI+o=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
<<<<<<< HEAD
      --replace-fail "setuptools ==" "setuptools >="
=======
      --replace-fail "setuptools <= 75.6.0" "setuptools"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  '';

  build-system = [ setuptools ];

<<<<<<< HEAD
  nativeCheckInputs = [ zope-testrunner ];

  checkPhase = ''
    runHook preCheck

    zope-testrunner --test-path=src

    runHook postCheck
  '';
=======
  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "src/zope/deprecation/tests.py" ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  pythonImportsCheck = [ "zope.deprecation" ];

  pythonNamespaces = [ "zope" ];

  meta = {
    homepage = "https://github.com/zopefoundation/zope.deprecation";
    description = "Zope Deprecation Infrastructure";
    changelog = "https://github.com/zopefoundation/zope.deprecation/blob/${version}/CHANGES.rst";
    license = lib.licenses.zpl21;
    maintainers = [ ];
  };
}
