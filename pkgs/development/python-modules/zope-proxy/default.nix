{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools
, zope-interface
}:

buildPythonPackage rec {
  pname = "zope-proxy";
  version = "5.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "zope.proxy";
    inherit version;
    hash = "sha256-93fVbCqy/PQNAmraHmfx45z2MY497rmhzVCH/MsfKG4=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [ zope-interface ];

  # circular deps
  doCheck = false;

  pythonImportsCheck = [
    "zope.proxy"
  ];

  meta = with lib; {
    homepage = "https://github.com/zopefoundation/zope.proxy";
    description = "Generic Transparent Proxies";
    changelog = "https://github.com/zopefoundation/zope.proxy/blob/${version}/CHANGES.rst";
    license = licenses.zpl21;
    maintainers = with maintainers; [ goibhniu ];
  };
}
