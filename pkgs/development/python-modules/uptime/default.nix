{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "uptime";
  version = "3.0.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fDACVHdbgHzkbj3LzaMKo7miBLnFenrB557m2+OUKXM=";
  };

  build-system = [ setuptools ];

  # Tests are not shipped
  doCheck = false;

  pythonImportsCheck = [ "uptime" ];

  meta = with lib; {
    description = "Cross-platform way to retrieve system uptime and boot time";
    homepage = "https://github.com/Cairnarvon/uptime";
    license = licenses.bsd2;
    maintainers = with maintainers; [ rob ];
  };
}
