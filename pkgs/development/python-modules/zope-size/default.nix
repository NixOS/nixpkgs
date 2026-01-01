{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  zope-i18nmessageid,
  zope-interface,
  unittestCheckHook,
  zope-component,
  zope-configuration,
  zope-security,
}:

buildPythonPackage rec {
  pname = "zope-size";
<<<<<<< HEAD
  version = "6.0";
=======
  version = "5.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zopefoundation";
    repo = "zope.size";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-jjI9NvfxnIWZrqDEpZ6FDlhDWZoqEUBliiyh+5PxOAg=";
=======
    hash = "sha256-9r7l3RgE9gvxJ2I5rFvNn/XIztecXW3GseGeM3MzfTU=";
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

  dependencies = [
    zope-i18nmessageid
    zope-interface
  ];

<<<<<<< HEAD
  optional-dependencies = {
    zcml = [
      zope-component
      zope-configuration
      zope-security
    ]
    ++ zope-component.optional-dependencies.zcml
    ++ zope-security.optional-dependencies.zcml;
  };

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pythonImportsCheck = [ "zope.size" ];

  nativeCheckInputs = [
    unittestCheckHook
<<<<<<< HEAD
  ]
  ++ lib.concatAttrValues optional-dependencies;
=======
    zope-component
    zope-configuration
    zope-security
  ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  unittestFlagsArray = [ "src/zope/size" ];

  pythonNamespaces = [ "zope" ];

  meta = {
    homepage = "https://github.com/zopefoundation/zope.size";
    description = "Interfaces and simple adapter that give the size of an object";
    changelog = "https://github.com/zopefoundation/zope.size/blob/${version}/CHANGES.rst";
    license = lib.licenses.zpl21;
    maintainers = [ ];
  };
}
