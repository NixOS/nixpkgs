{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  zope-proxy,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "zope-deferredimport";
  version = "5.0";
  pyproject = true;

  src = fetchPypi {
    pname = "zope.deferredimport";
    inherit version;
    hash = "sha256-Orvw4YwfF2WRTs0dQbVJ5NBFshso5AZfsMHeCtc2ssM=";
  };

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
