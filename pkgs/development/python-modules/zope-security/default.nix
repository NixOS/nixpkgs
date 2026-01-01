{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  zope-component,
  zope-i18nmessageid,
  zope-interface,
  zope-location,
  zope-proxy,
  zope-schema,
  pytz,
  zope-configuration,
  btrees,
  unittestCheckHook,
  zope-exceptions,
  zope-testing,
}:

buildPythonPackage rec {
  pname = "zope-security";
<<<<<<< HEAD
  version = "8.1";
=======
  version = "7.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zopefoundation";
    repo = "zope.security";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-qik1tuH0w0W21Md6YXc5csCbMrFifxaJvGgi2nB4FrI=";
=======
    hash = "sha256-p+9pCcBsCJY/V6vraVZHMr5VwYHFe217AbRVoSnDphs=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
<<<<<<< HEAD
      --replace-fail "setuptools ==" "setuptools >="
  '';

  build-system = [
    setuptools
    zope-proxy
  ];
=======
      --replace-fail "setuptools<74" "setuptools"
  '';

  build-system = [ setuptools ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  dependencies = [
    zope-component
    zope-i18nmessageid
    zope-interface
    zope-location
    zope-proxy
    zope-schema
  ];

  optional-dependencies = {
    pytz = [ pytz ];
    # untrustedpython = [ zope-untrustedpython ];
    zcml = [ zope-configuration ];
  };

  pythonImportsCheck = [ "zope.security" ];

  nativeCheckInputs = [
    btrees
    unittestCheckHook
    zope-exceptions
    zope-testing
  ]
<<<<<<< HEAD
  ++ lib.concatAttrValues optional-dependencies;
=======
  ++ lib.flatten (lib.attrValues optional-dependencies);
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  # Import process is too complex and some tests fail
  preCheck = ''
    rm -r src/zope/security/tests/test_metaconfigure.py
    rm -r src/zope/security/tests/test_proxy.py
    rm -r src/zope/security/tests/test_zcml_functest.py
  '';

  unittestFlagsArray = [ "src/zope/security/tests" ];

  pythonNamespaces = [ "zope" ];

  meta = {
    description = "Zope Security Framework";
    homepage = "https://github.com/zopefoundation/zope.security";
    changelog = "https://github.com/zopefoundation/zope.security/blob/${src.tag}/CHANGES.rst";
    license = lib.licenses.zpl21;
    maintainers = [ ];
  };
}
