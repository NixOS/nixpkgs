{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  zope-proxy,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "zope-deferredimport";
  version = "6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zopefoundation";
    repo = "zope.deferredimport";
    tag = version;
    hash = "sha256-7Q8+Cew5987+CjUOxqpwMFXWdw+/B28tOEXRYC0SRyI=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools ==" "setuptools >="
  '';

  build-system = [ setuptools ];

  dependencies = [ zope-proxy ];

  pythonImportsCheck = [ "zope.deferredimport" ];

  nativeCheckInputs = [ unittestCheckHook ];

  unittestFlagsArray = [ "src/zope/deferredimport" ];

  pythonNamespaces = [ "zope" ];

  meta = {
    description = "Allows you to perform imports names that will only be resolved when used in the code";
    homepage = "https://github.com/zopefoundation/zope.deferredimport";
    changelog = "https://github.com/zopefoundation/zope.deferredimport/blob/${version}/CHANGES.rst";
    license = lib.licenses.zpl21;
  };
}
