{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
<<<<<<< HEAD
=======
  zope-testrunner,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "zope-i18nmessageid";
<<<<<<< HEAD
  version = "8.0";
=======
  version = "7.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zopefoundation";
    repo = "zope.i18nmessageid";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-lMHmKWwR9D9HW+paV1mDVAirOe0wBD8VrJ67NZoROtg=";
  };

=======
    hash = "sha256-rdTs1pNMKpPAR2CewXdg1KmI61Sw5r62OobYlJHsUaQ=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools<74" "setuptools"
  '';

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  build-system = [ setuptools ];

  nativeCheckInputs = [
    unittestCheckHook
<<<<<<< HEAD
=======
    zope-testrunner
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  unittestFlagsArray = [ "src/zope/i18nmessageid" ];

  pythonImportsCheck = [ "zope.i18nmessageid" ];

  pythonNamespaces = [ "zope" ];

  meta = {
    homepage = "https://github.com/zopefoundation/zope.i18nmessageid";
    description = "Message Identifiers for internationalization";
    changelog = "https://github.com/zopefoundation/zope.i18nmessageid/blob/${version}/CHANGES.rst";
    license = lib.licenses.zpl21;
    maintainers = [ ];
  };
}
