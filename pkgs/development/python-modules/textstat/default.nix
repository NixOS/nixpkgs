{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nltk,
  setuptools,
  pyphen,
  pytestCheckHook,
}:
buildPythonPackage (finalAttrs: {
  version = "0.7.13";
  pname = "textstat";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "textstat";
    repo = "textstat";
    tag = finalAttrs.version;
    hash = "sha256-VMWwhwyGMFaKNLHoDG3gw1/jzSYCDBH3Yq4pE4JZTTo=";
  };

  # Version 0.7.13 still has 0.7.12 set as it's version. That makes pythonMetadataCheckPhase unhappy.
  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "0.7.12" "0.7.13"
    substituteInPlace textstat/__init__.py \
      --replace-fail "0, 7, 12" "0, 7, 13"
  '';

  build-system = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  dependencies = [
    pyphen
    nltk
  ];

  pythonImportsCheck = [
    "textstat"
  ];

  env.NLTK_DATA = nltk.data.cmudict;

  meta = {
    description = "Python package to calculate readability statistics of a text object";
    homepage = "https://textstat.org";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aleksana ];
  };
})
