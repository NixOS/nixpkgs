{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  zope-interface,
  zope-proxy,
  zope-schema,
  zope-component,
  zope-configuration,
  zope-copy,
  unittestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "zope-location";
  version = "6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zopefoundation";
    repo = "zope.location";
    tag = finalAttrs.version;
    hash = "sha256-s7HZda+U87P62elX/KbDp2o9zAplgFVmnedDI/uq2sk=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools ==" "setuptools >="
  '';

  build-system = [ setuptools ];

  dependencies = [
    zope-interface
    zope-proxy
    zope-schema
  ];

  optional-dependencies = {
    zcml = [ zope-configuration ];
    component = [ zope-component ];
    copy = [ zope-copy ];
  };

  pythonImportsCheck = [ "zope.location" ];

  nativeCheckInputs = [ unittestCheckHook ];

  unittestFlags = [ "--start-directory=src/zope/location/tests" ];

  pythonNamespaces = [ "zope" ];

  meta = {
    homepage = "https://github.com/zopefoundation/zope.location/";
    description = "Zope Location";
    changelog = "https://github.com/zopefoundation/zope.location/blob/${finalAttrs.src.tag}/CHANGES.rst";
    license = lib.licenses.zpl21;
    maintainers = [ ];
  };
})
