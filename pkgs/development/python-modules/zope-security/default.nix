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
  version = "7.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zopefoundation";
    repo = "zope.security";
    tag = version;
    hash = "sha256-p+9pCcBsCJY/V6vraVZHMr5VwYHFe217AbRVoSnDphs=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools<74" "setuptools"
  '';

  build-system = [ setuptools ];

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
  ++ lib.concatAttrValues optional-dependencies;

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
