{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools
, zope_interface
}:

buildPythonPackage rec {
  pname = "zope-proxy";
  version = "5.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "zope.proxy";
    inherit version;
    hash = "sha256-d3e9P4986nRSFyYgLhptUVPb9knyBOJQBYrQOvRqQxg=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [ zope_interface ];

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
