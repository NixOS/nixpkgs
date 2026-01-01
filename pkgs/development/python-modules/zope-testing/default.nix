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
<<<<<<< HEAD
  version = "6.0";
=======
  version = "5.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zopefoundation";
    repo = "zope.testing";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-px1+lS1U0lmmQrXJuxFTsX3N8e2mj5Yhckfis5++EX8=";
=======
    hash = "sha256-G9RfRsXSzQ92HeBF5dRTI+1XEz1HM3DuB0ypZ61uHfw=";
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
