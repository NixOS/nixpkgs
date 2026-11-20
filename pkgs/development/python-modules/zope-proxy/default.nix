{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  zope-interface,
}:

buildPythonPackage rec {
  pname = "zope-proxy";
  version = "7.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zopefoundation";
    repo = "zope.proxy";
    tag = version;
    hash = "sha256-2Qtt0YuT1HmGPXPJT5Hbmrk4HYsLDBonU9IpZARqksc=";
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
    changelog = "https://github.com/zopefoundation/zope.proxy/blob/${src.tag}/CHANGES.rst";
    license = lib.licenses.zpl21;
    maintainers = [ ];
  };
}
