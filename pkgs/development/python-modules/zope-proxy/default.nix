{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  zope-interface,
}:

buildPythonPackage rec {
  pname = "zope-proxy";
  version = "7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zopefoundation";
    repo = "zope.proxy";
    tag = version;
    hash = "sha256-1u9Yn6j8tBMmAZmb/0L/lZUE/yC0OP8K825QBixxKQM=";
  };

  build-system = [ setuptools ];

  dependencies = [ zope-interface ];

  # circular deps
  doCheck = false;

  pythonImportsCheck = [ "zope.proxy" ];

  pythonNamespaces = [ "zope" ];

  meta = {
    homepage = "https://github.com/zopefoundation/zope.proxy";
    description = "Generic Transparent Proxies";
    changelog = "https://github.com/zopefoundation/zope.proxy/blob/${version}/CHANGES.rst";
    license = lib.licenses.zpl21;
    maintainers = [ ];
  };
}
