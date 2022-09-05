{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
, pythonOlder
}:

buildPythonPackage rec {
  pname = "twitter";
  version = "1.19.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-g7jSSEpsdEihGuHG9MJTNVFe6NyB272vEsvAocRo72U=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  doCheck = false;

  pythonImportsCheck = [
    "twitter"
  ];

  meta = with lib; {
    description = "Twitter API library";
    homepage = "https://mike.verdone.ca/twitter/";
    license = licenses.mit;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
