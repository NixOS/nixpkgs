{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  zodbpickle,
  zope-interface,
  zope-location,
  zope-schema,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "zope-copy";
<<<<<<< HEAD
  version = "6.0";
=======
  version = "5.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zopefoundation";
    repo = "zope.copy";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-hYeLUSwAq5rK4TRngvNQGR4Fdimb2k5dHtFdptMVqPo=";
=======
    hash = "sha256-uQUvfZGrMvtClXa8tLKZFYehbcBIRx7WQnumUrdQjIk=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
<<<<<<< HEAD
      --replace-fail "setuptools ==" "setuptools >="
=======
      --replace-fail "setuptools < 74" "setuptools"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  '';

  build-system = [ setuptools ];

  dependencies = [
    zodbpickle
    zope-interface
  ];

  pythonImportsCheck = [ "zope.copy" ];

  nativeCheckInputs = [
    unittestCheckHook
    zope-location
    zope-schema
  ];

  unittestFlagsArray = [
    "-s"
    "src/zope/copy"
  ];

  pythonNamespaces = [ "zope" ];

  meta = {
    description = "Pluggable object copying mechanism";
    homepage = "https://github.com/zopefoundation/zope.copy";
    changelog = "https://github.com/zopefoundation/zope.copy/blob/${src.tag}/CHANGES.rst";
    license = lib.licenses.zpl21;
    maintainers = [ ];
  };
}
