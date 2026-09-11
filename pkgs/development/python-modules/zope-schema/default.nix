{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  zope-event,
  zope-interface,
  unittestCheckHook,
  zope-i18nmessageid,
}:

buildPythonPackage (finalAttrs: {
  pname = "zope-schema";
  version = "8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zopefoundation";
    repo = "zope.schema";
    tag = finalAttrs.version;
    hash = "sha256-pO3yL0gej2PGD01ySiPJPU66P/9hW73T2n/ZnUPa3C0=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools ==" "setuptools >="
  '';

  build-system = [ setuptools ];

  dependencies = [
    zope-event
    zope-interface
  ];

  pythonImportsCheck = [ "zope.schema" ];

  nativeCheckInputs = [
    unittestCheckHook
    zope-i18nmessageid
  ];

  unittestFlags = [ "--start-directory=src/zope/schema/tests" ];

  pythonNamespaces = [ "zope" ];

  meta = {
    homepage = "https://github.com/zopefoundation/zope.schema";
    description = "zope.interface extension for defining data schemas";
    changelog = "https://github.com/zopefoundation/zope.schema/blob/${finalAttrs.src.tag}/CHANGES.rst";
    license = lib.licenses.zpl21;
    maintainers = [ ];
  };
})
