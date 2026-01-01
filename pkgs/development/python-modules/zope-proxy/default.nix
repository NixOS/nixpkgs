{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  zope-interface,
}:

buildPythonPackage rec {
  pname = "zope-proxy";
<<<<<<< HEAD
  version = "7.0";
=======
  version = "6.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zopefoundation";
    repo = "zope.proxy";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-1u9Yn6j8tBMmAZmb/0L/lZUE/yC0OP8K825QBixxKQM=";
  };

=======
    hash = "sha256-RgkUojCAfwAGv8Jek2Ucg0KMtPviwXjuiO70iisParM=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools<74" "setuptools"
  '';

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
