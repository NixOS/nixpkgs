{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  zope-interface,
}:

buildPythonPackage rec {
  pname = "zope-proxy";
  version = "6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zopefoundation";
    repo = "zope.proxy";
    tag = version;
    hash = "sha256-RgkUojCAfwAGv8Jek2Ucg0KMtPviwXjuiO70iisParM=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools<74" "setuptools"
  '';

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
